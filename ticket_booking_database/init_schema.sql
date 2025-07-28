-- Ticket Booking Application Database Schema

-- USERS TABLE
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(128) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(128) NOT NULL,
    phone VARCHAR(32),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- EVENTS TABLE
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255) NOT NULL,
    start_datetime DATETIME NOT NULL,
    end_datetime DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_event_title (title),
    INDEX idx_event_location (location)
) ENGINE=InnoDB;

-- TICKETS TABLE
CREATE TABLE tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    ticket_type VARCHAR(64) NOT NULL,          -- e.g., Regular, VIP, etc.
    price DECIMAL(10,2) NOT NULL,
    total_quantity INT NOT NULL,
    remaining_quantity INT NOT NULL,
    sales_start DATETIME,
    sales_end DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    INDEX idx_ticket_event_id (event_id),
    INDEX idx_ticket_type (ticket_type)
) ENGINE=InnoDB;

-- RESERVATIONS (ORDERS) TABLE
CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    status ENUM('reserved','cancelled','booked') NOT NULL DEFAULT 'reserved',
    reserved_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    booked_at DATETIME,
    cancelled_at DATETIME,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    INDEX idx_reservation_user (user_id),
    INDEX idx_reservation_event (event_id),
    INDEX idx_reservation_status (status)
) ENGINE=InnoDB;

-- RESERVATION_TICKETS TABLE (Reservation-to-Ticket Mapping, to allow for multiple ticket types/quantities per reservation)
CREATE TABLE reservation_tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    ticket_id INT NOT NULL,
    quantity INT NOT NULL,
    price_each DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
    INDEX idx_res_ticket_reservation (reservation_id),
    INDEX idx_res_ticket_ticket (ticket_id)
) ENGINE=InnoDB;

-- EXAMPLES OF ADDITIONAL INDEXING AS NEEDED FOR QUERIES (Adjust as per load/performance)
-- CREATE INDEX idx_reserved_at ON reservations(reserved_at);
-- CREATE INDEX idx_sales_period ON tickets(sales_start, sales_end);

-- End of schema
