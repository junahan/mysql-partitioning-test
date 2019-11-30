/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50725
 Source Host           : localhost:3306
 Source Schema         : test

 Target Server Type    : MySQL
 Target Server Version : 50725
 File Encoding         : 65001

 Date: 22/10/2019 10:25:41
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for pt_ten_millions_original
-- ----------------------------
DROP TABLE IF EXISTS `pt_ten_millions_original`;
CREATE TABLE `pt_ten_millions_original` (
  `id` varchar(32) NOT NULL COMMENT 'ID',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品编码',
  `goods_name` varchar(50) DEFAULT NULL COMMENT '商品名称',
  `in_date` datetime(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pt_tmo_id` (`id`),
  KEY `pt_tmo_goods_id` (`goods_id`),
  KEY `pt_tmo_in_date` (`in_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
