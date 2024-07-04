/*
 Navicat Premium Data Transfer

 Source Server         : sql_final
 Source Server Type    : MySQL
 Source Server Version : 80035
 Source Host           : localhost:3306
 Source Schema         : coffee_shop

 Target Server Type    : MySQL
 Target Server Version : 80035
 File Encoding         : 65001

 Date: 03/07/2024 14:39:13
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for balances
-- ----------------------------
DROP TABLE IF EXISTS `balances`;
CREATE TABLE `balances`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `balance` decimal(10, 2) NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  CONSTRAINT `balances_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of balances
-- ----------------------------
INSERT INTO `balances` VALUES (1, 2, 5000.00);
INSERT INTO `balances` VALUES (2, 3, 15.00);
INSERT INTO `balances` VALUES (4, 6, 0.00);

-- ----------------------------
-- Table structure for coffees
-- ----------------------------
DROP TABLE IF EXISTS `coffees`;
CREATE TABLE `coffees`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `quantity` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coffees
-- ----------------------------
INSERT INTO `coffees` VALUES (1, 'Espresso', 30.00, 69);
INSERT INTO `coffees` VALUES (2, 'Latte', 4.00, 36);
INSERT INTO `coffees` VALUES (3, 'Cappuccino', 4.50, 30);
INSERT INTO `coffees` VALUES (4, 'tea coffee', 13.00, 7);
INSERT INTO `coffees` VALUES (15, 'cola coffee', 9.00, 111);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `coffee_id` int(0) NOT NULL,
  `quantity` int(0) NOT NULL,
  `total_price` decimal(10, 2) NOT NULL,
  `order_date` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `temperature` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `coffee_id`(`coffee_id`) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`coffee_id`) REFERENCES `coffees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 1, 1, 2, 6.00, '2024-05-25 13:47:07', 'hot');
INSERT INTO `orders` VALUES (21, 2, 1, 1, 0.06, '2024-05-25 13:58:18', 'cold');
INSERT INTO `orders` VALUES (22, 2, 1, 1, 0.06, '2024-05-25 14:14:46', 'hot');
INSERT INTO `orders` VALUES (23, 2, 1, 1, 0.06, '2024-05-25 14:15:39', 'hot');
INSERT INTO `orders` VALUES (28, 2, 1, 1, 30.00, '2024-05-25 21:08:10', 'hot');
INSERT INTO `orders` VALUES (29, 2, 1, 4, 120.00, '2024-05-25 21:49:03', 'hot');
INSERT INTO `orders` VALUES (30, 2, 1, 1, 30.00, '2024-05-25 21:53:14', 'hot');
INSERT INTO `orders` VALUES (31, 2, 1, 1, 30.00, '2024-05-25 21:53:18', 'hot');
INSERT INTO `orders` VALUES (32, 2, 1, 1, 30.00, '2024-05-25 21:53:21', 'hot');
INSERT INTO `orders` VALUES (33, 2, 1, 1, 30.00, '2024-05-25 21:55:17', 'hot');
INSERT INTO `orders` VALUES (34, 2, 1, 1, 30.00, '2024-05-25 21:55:21', 'hot');
INSERT INTO `orders` VALUES (35, 2, 1, 1, 30.00, '2024-05-25 21:57:32', 'hot');
INSERT INTO `orders` VALUES (36, 2, 2, 1, 4.00, '2024-05-25 21:57:41', 'cold');
INSERT INTO `orders` VALUES (37, 2, 1, 1, 30.00, '2024-05-25 21:58:01', 'hot');
INSERT INTO `orders` VALUES (38, 2, 2, 1, 4.00, '2024-05-25 21:58:05', 'hot');
INSERT INTO `orders` VALUES (39, 2, 2, 1, 4.00, '2024-05-25 21:58:39', 'hot');
INSERT INTO `orders` VALUES (40, 2, 2, 1, 4.00, '2024-05-25 22:00:36', 'hot');
INSERT INTO `orders` VALUES (41, 2, 2, 1, 4.00, '2024-05-25 22:05:20', 'hot');
INSERT INTO `orders` VALUES (42, 2, 1, 1, 30.00, '2024-05-25 22:05:52', 'hot');
INSERT INTO `orders` VALUES (43, 2, 1, 1, 30.00, '2024-05-25 22:09:50', 'hot');
INSERT INTO `orders` VALUES (44, 2, 2, 1, 4.00, '2024-05-25 22:09:55', 'cold');
INSERT INTO `orders` VALUES (45, 2, 1, 1, 30.00, '2024-05-25 22:10:17', 'hot');
INSERT INTO `orders` VALUES (46, 2, 1, 1, 30.00, '2024-05-25 22:11:01', 'hot');
INSERT INTO `orders` VALUES (47, 2, 1, 1, 30.00, '2024-05-25 22:13:21', 'hot');
INSERT INTO `orders` VALUES (48, 2, 1, 1, 30.00, '2024-05-25 22:13:49', 'hot');
INSERT INTO `orders` VALUES (49, 2, 1, 1, 30.00, '2024-05-25 22:13:55', 'hot');
INSERT INTO `orders` VALUES (50, 2, 1, 1, 30.00, '2024-05-25 22:13:57', 'hot');
INSERT INTO `orders` VALUES (51, 2, 1, 1, 30.00, '2024-05-25 22:15:02', 'hot');
INSERT INTO `orders` VALUES (52, 2, 1, 1, 30.00, '2024-05-25 22:22:37', 'hot');
INSERT INTO `orders` VALUES (53, 2, 1, 1, 30.00, '2024-05-25 22:22:40', 'hot');

-- ----------------------------
-- Table structure for points
-- ----------------------------
DROP TABLE IF EXISTS `points`;
CREATE TABLE `points`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NULL DEFAULT NULL,
  `points` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  CONSTRAINT `points_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of points
-- ----------------------------
INSERT INTO `points` VALUES (1, 2, 450);
INSERT INTO `points` VALUES (2, 3, 80);

-- ----------------------------
-- Table structure for recharges
-- ----------------------------
DROP TABLE IF EXISTS `recharges`;
CREATE TABLE `recharges`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NULL DEFAULT NULL,
  `amount` decimal(10, 2) NULL DEFAULT NULL,
  `recharge_date` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  CONSTRAINT `recharges_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recharges
-- ----------------------------
INSERT INTO `recharges` VALUES (1, 2, 20.00, '2024-05-24 18:33:20');
INSERT INTO `recharges` VALUES (2, 3, 15.00, '2024-05-24 18:33:20');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role` enum('owner','customer') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'owner', 'hashed_password_1', 'owner');
INSERT INTO `users` VALUES (2, 'customer1', 'hashed_password_2', 'customer');
INSERT INTO `users` VALUES (3, 'customer2', 'hashed_password_3', 'customer');
INSERT INTO `users` VALUES (6, 'dfg', '', 'customer');

-- ----------------------------
-- View structure for userpoints
-- ----------------------------
DROP VIEW IF EXISTS `userpoints`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `userpoints` AS select `orders`.`user_id` AS `user_id`,sum(`orders`.`total_price`) AS `total_price`,sum(`points`.`points`) AS `total_points` from (`orders` left join `points` on((`orders`.`user_id` = `points`.`user_id`))) group by `orders`.`user_id`;

-- ----------------------------
-- Procedure structure for update_coffee_quantity
-- ----------------------------
DROP PROCEDURE IF EXISTS `update_coffee_quantity`;
delimiter ;;
CREATE PROCEDURE `update_coffee_quantity`(IN coffee_id INT, IN quantity_change INT)
BEGIN
    UPDATE coffees
    SET quantity = quantity + quantity_change
    WHERE id = coffee_id;
END
;;
delimiter ;
-- ----------------------------
-- Table structure for membership_card
-- ----------------------------
CREATE TABLE `membership_card` (
  `card_id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `card_number` VARCHAR(50) UNIQUE NOT NULL,
  `expiration_date` DATE NOT NULL,
  `membership_level` VARCHAR(50) NOT NULL,
  `points` INT DEFAULT 0,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of membership_card
-- ----------------------------
INSERT INTO `membership_card` (`card_id`, `user_id`, `card_number`, `expiration_date`, `membership_level`, `points`) VALUES
(1, 2, '1234567890', '2025-12-31', 'Gold', 100),
(2, 3, '0987654321', '2025-12-31', 'Silver', 50);
SET FOREIGN_KEY_CHECKS = 1;

