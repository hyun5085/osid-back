-- init-meta.sql

-- 1) 메타DB 생성
CREATE DATABASE IF NOT EXISTS meta_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- 2) osid 앱용 DB 생성
CREATE DATABASE IF NOT EXISTS osid
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- 3) 기존 car_order DB 생성 (기존 init.sql 용)
CREATE DATABASE IF NOT EXISTS car_order
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

