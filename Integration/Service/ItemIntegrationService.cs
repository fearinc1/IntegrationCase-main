using System.Collections.Concurrent;
using Integration.Common;
using Integration.Backend;

namespace Integration.Service;

public sealed class ItemIntegrationService
{
    //This is a dependency that is normally fulfilled externally.
    private ItemOperationBackend ItemIntegrationBackend { get; set; } = new();

    // Dictionary to store locks for item content to avoid contention
    private readonly ConcurrentDictionary<string, object> _itemLocks = new();

    // This is called externally and can be called multithreaded, in parallel.
    // More than one item with the same content should not be saved. However,
    // calling this with different contents at the same time is OK, and should
    // be allowed for performance reasons.
    public Result SaveItem(string itemContent)
    {
        // Get or create a lock object specific to the item content
        var itemLock = _itemLocks.GetOrAdd(itemContent, new object());

        lock (itemLock)
        {
            try
            {
                // Check the backend to see if the content is already saved.
                if (ItemIntegrationBackend.FindItemsWithContent(itemContent).Count != 0)
                {
                    return new Result(false, $"Duplicate item received with content {itemContent}.");
                }

                var item = ItemIntegrationBackend.SaveItem(itemContent);

                return new Result(true, $"Item with content {itemContent} saved with id {item.Id}");
            }
            finally
            {
                // Once the item is processed, we can remove the lock for this item content
                _ = _itemLocks.TryRemove(itemContent, out _);
            }
        }
    }

    public List<Item> GetAllItems()
    {
        return ItemIntegrationBackend.GetAllItems();
    }
}