SET FOREIGN_KEY_CHECKS = 0;

-- ล้างตารางเดิม (เพื่อความสะอาด)
DROP TABLE IF EXISTS `borrowings`;
DROP TABLE IF EXISTS `deleted_borrowings`;
DROP VIEW IF EXISTS `deleted_borrowings_view`;
DROP TABLE IF EXISTS `equipment`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `users`;

-- 1. สร้างตาราง users (เพิ่มคอลัมน์ student_id, first_name, profile_image)
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `student_id` varchar(20) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT 'default.jpg',
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- นำเข้าข้อมูล Users ของคุณ
insert into `users`(`id`,`username`,`password`,`role`,`created_at`) values 
(1,'admin','$2y$10$6.yQHlMSssmmxuLIErk6te13BNGX5u5D2RPiLWuUxVzWWLibRzbUu','admin','2025-05-01 13:19:53'),
(2,'user','$2y$10$.fZTSg2MZW3IpE6YzUA5cuLG2S.UOyoa.QtwPUmfV6EX56UT8TUn.','user','2025-05-01 13:32:59'),
(6,'nhum','$2y$10$5PygIZ1/MbUSvnpgyJcLCeM5clYBUV9Wfs0yVQM/x.er1aASafesi','admin','2026-01-27 21:55:41'),
(9,'admin2','$2y$10$.sFbTRw9gzMVsBN/r/JDF.1ajreiO7sDzju8A5Cir7IVbgAChn0si','admin','2026-01-27 22:52:41'),
(10,'user2','$2y$10$4RrMbbCakpIXHM9iAkqPZu2RPf/yAGQ58YgT.6F8u32U/bhZsNbbu','user','2026-01-27 22:55:58');

-- 2. สร้างตาราง categories
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- นำเข้าข้อมูล Categories ของคุณ
insert into `categories`(`id`,`name`,`created_at`) values 
(1,'Electronics','2025-05-01 13:19:53'),(2,'Tools','2025-05-01 13:19:53'),(5,'กล้อง','2026-01-27 19:16:03');

-- 3. สร้างตาราง equipment
CREATE TABLE `equipment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `equipment_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- นำเข้าข้อมูล Equipment ของคุณ
insert into `equipment`(`id`,`name`,`description`,`category_id`,`quantity`,`image`,`created_at`) values 
(1,'Electronics 1','Electronics 1',1,22,'oinam-TJHXkCp2bBo-unsplash.jpg','2025-05-01 13:30:50'),
(2,'Tools1','Tools1',2,30,'oinam-TJHXkCp2bBo-unsplash.jpg','2025-05-01 13:31:14'),
(3,'Electronics 2','Electronics 2',1,10,'oinam-TJHXkCp2bBo-unsplash.jpg','2025-05-01 13:30:50'),
(4,'Tools2','Tools2',2,10,'oinam-TJHXkCp2bBo-unsplash.jpg','2025-05-01 13:31:14'),
(5,'Electronics 3','Electronics 3',1,7,'oinam-TJHXkCp2bBo-unsplash.jpg','2025-05-01 13:30:50'),
(6,'Tools3','Tools3',2,19,'oinam-TJHXkCp2bBo-unsplash.jpg','2025-05-01 13:31:14'),
(10,'Electronics 4','Electronics 4',1,2,'oinam-TJHXkCp2bBo-unsplash.jpg','2025-05-01 13:30:50'),
(11,'Tools4','Tools4',2,17,'oinam-TJHXkCp2bBo-unsplash.jpg','2025-05-01 13:31:14'),
(12,'กล้อง','ดกหดกดหกด',5,6,'download.jpg','2026-01-27 19:16:53'),
(14,'กล้อง990','',5,100,'1769528425.jpg','2026-01-27 22:30:04'),
(15,'ดหกดหกดกหด','ดหกดหกดหกด',5,30,'1769528445.jpg','2026-01-27 22:40:45');

-- 4. สร้างตาราง borrowings (เพิ่มคอลัมน์ approval, pickup และ is_deleted)
CREATE TABLE `borrowings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `status` enum('borrowed','returned') DEFAULT 'borrowed',
  `approval_status` ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
  `approved_by` INT(11) NULL,
  `approved_at` TIMESTAMP NULL,
  `rejection_reason` TEXT NULL,
  `pickup_confirmed` TINYINT(1) NOT NULL DEFAULT 0,
  `pickup_time` TIMESTAMP NULL,
  `is_deleted` TINYINT(1) DEFAULT 0 COMMENT '0=ไม่ถูกลบ, 1=ถูกลบ',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `equipment_id` (`equipment_id`),
  CONSTRAINT `borrowings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `borrowings_ibfk_2` FOREIGN KEY (`equipment_id`) REFERENCES `equipment` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- นำเข้าข้อมูล Borrowings ของคุณ
insert into `borrowings`(`id`,`user_id`,`equipment_id`,`quantity`,`borrow_date`,`return_date`,`status`,`created_at`) values 
(1,2,1,2,'2025-05-01','2025-05-01','returned','2025-05-01 15:08:13'),
(2,2,6,2,'2025-05-01','2026-01-27','returned','2025-05-01 15:08:13'),
(3,2,1,5,'2025-05-01','2026-01-27','returned','2025-05-01 15:09:38'),
(4,2,5,5,'2025-05-01','2026-01-27','returned','2025-05-01 15:17:35'),
(5,2,3,2,'2025-05-02','2026-01-27','returned','2025-05-02 10:45:20'),
(6,2,2,2,'2025-05-02','2026-01-27','returned','2025-05-02 10:45:20'),
(7,2,12,1,'2026-01-27','2026-01-27','returned','2026-01-27 19:21:09'),
(8,2,12,1,'2026-01-27','2026-01-27','returned','2026-01-27 19:21:15'),
(9,2,1,1,'2026-01-27','2026-01-27','returned','2026-01-27 19:36:19'),
(10,2,2,1,'2026-01-27','2026-01-27','returned','2026-01-27 19:36:19'),
(11,2,1,1,'2026-01-27','2026-01-27','returned','2026-01-27 19:39:35'),
(12,2,2,1,'2026-01-27','2026-01-27','returned','2026-01-27 19:39:35');

-- ปรับปรุงข้อมูลที่เคยคืนแล้ว ให้มีสถานะ อนุมัติแล้ว และรับของแล้ว เพื่อไม่ให้ระบบใหม่ Error
UPDATE `borrowings` SET `approval_status` = 'approved', `pickup_confirmed` = 1, `approved_by` = 1 WHERE `status` = 'returned';

-- 5. สร้างตาราง deleted_borrowings สำหรับรองรับระบบลบลงถังขยะ
CREATE TABLE IF NOT EXISTS `deleted_borrowings` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `original_id` INT NOT NULL,
    `equipment_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `borrow_date` DATETIME NOT NULL,
    `return_date` DATETIME NULL,
    `status` ENUM('borrowed', 'returned') NOT NULL,
    `approval_status` ENUM('pending', 'approved', 'rejected') NOT NULL,
    `pickup_confirmed` TINYINT(1) DEFAULT 0,
    `pickup_time` DATETIME NULL,
    `approved_by` INT NULL,
    `approved_at` DATETIME NULL,
    `deleted_at` DATETIME NOT NULL,
    `deleted_by` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`equipment_id`) REFERENCES `equipment`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
