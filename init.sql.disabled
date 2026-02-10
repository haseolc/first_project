USE admin_db;

DROP TABLE IF EXISTS admins;
CREATE TABLE admins (
    admin_id VARCHAR(50) PRIMARY KEY,
    admin_pw VARCHAR(255) NOT NULL
);

INSERT INTO admins (admin_id, admin_pw) VALUES
('admin', SHA2('ad123@', 256)),
('master', SHA2('ma555#', 256)),
('leader', SHA2('ldr445!', 256)),
('security', SHA2('secu369@', 256)),
('db_admin', SHA2('dadm@511', 256)),
('k3s_manager', SHA2('km2253@', 256)),
('infra_manager', SHA2('ifm1246!', 256)),
('db_manager', SHA2('24maks5', 256)),
('infra_admin', SHA2('aozk311@', 256)),
('k3s_admin', SHA2('rkskekfk216', 256));
