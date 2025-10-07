
bool checkCollision(player, block){
    final hitbox = player.hitbox;
    final playerX = player.position.x + hitbox.offsetX;
    final playerY = player.position.y + hitbox.offsetY;
    final playerWidth = hitbox.width;
    final playerHeight = hitbox.height;

    final blockX = block.x;
    final blockY = block.y;
    final blockWidth = block.width;
    final blockHeight = block.height;

    final fixX = player.scale.x < 0 ? playerX - hitbox.offsetX * 2 - playerWidth : playerX;
    final fixY = block.isPlatform ? playerY + playerHeight : playerY;

    return (
        fixY < blockY + blockHeight &&
        fixY + playerHeight > blockY &&
        fixX < blockX + blockWidth &&
        fixX + playerWidth > blockX   
    );

}