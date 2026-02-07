CREATE DATABASE IF NOT EXISTS admin_db;

USE admin_db;

CREATE TABLE IF NOT EXISTS admins (
    admin_id VARCHAR(20) PRIMARY KEY,
    admin_pw VARCHAR(60) NOT NULL
);

INSERT INTO admins (admin_id, admin_pw) VALUES
('admin01', 'Init@Admin01!'),
('admin02', 'Init@Admin02!');
