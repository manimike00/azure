output "redis" {
  value = azurerm_redis_cache.redis.name
}

output "redis_id" {
  value = azurerm_redis_cache.redis.id
}