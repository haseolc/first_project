CREATE DATABASE IF NOT EXISTS admin_db;
USE admin_db;

DROP TABLE IF EXISTS admins;
CREATE TABLE admins (
    admin_id VARCHAR(50) PRIMARY KEY,
    password_hash VARCHAR(255) NOT NULL
);

INSERT INTO admins (admin_id, password_hash) VALUES
('admin', SHA2('123456', 256)),
('master', SHA2('234561', 256)),
('leader', SHA2('345612', 256)),
('security', SHA2('456123', 256)),
('db_admin', SHA2('561234', 256)),
('k3s_admin', SHA2('543216', 256));
('infra_admin', SHA2('654321', 256)),
('db_manager', SHA2('246135', 256)),
('k3s_manager', SHA2('612345', 256)),
('infra_manager', SHA2('135246', 256)),



