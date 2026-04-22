-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: localhost
-- Létrehozás ideje: 2026. Ápr 21. 17:35
-- Kiszolgáló verziója: 10.4.28-MariaDB
-- PHP verzió: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `carrentalpro_db`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `rentalagent_applications`
--

CREATE TABLE `rentalagent_applications` (
  `application_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `application_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `decision_date` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `rentals`
--

CREATE TABLE `rentals` (
  `rental_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `actual_return_date` datetime DEFAULT NULL,
  `pickup_location` varchar(100) NOT NULL,
  `return_location` varchar(100) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `rental_status` enum('pending_approval','approved','rejected','in_progress','completed','cancelled') NOT NULL DEFAULT 'pending_approval',
  `rental_request_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `rentalagent_decision_date` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `rentals`
--

INSERT INTO `rentals` (`rental_id`, `user_id`, `vehicle_id`, `start_date`, `end_date`, `actual_return_date`, `pickup_location`, `return_location`, `total_price`, `rental_status`, `rental_request_date`, `rentalagent_decision_date`, `created_at`, `updated_at`) VALUES
(1, 5, 1, '2024-06-01 08:00:00', '2024-06-05 08:00:00', NULL, 'Budapest', 'Budapest', 60000.00, 'completed', '2026-04-21 15:35:29', NULL, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(2, 6, 4, '2024-07-10 10:00:00', '2024-07-12 10:00:00', NULL, 'Debrecen', 'Debrecen', 36000.00, 'approved', '2026-04-21 15:35:29', NULL, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(3, 7, 6, '2024-08-01 09:00:00', '2024-08-05 09:00:00', NULL, 'Szeged', 'Szeged', 180000.00, 'pending_approval', '2026-04-21 15:35:29', NULL, '2026-04-21 15:35:29', '2026-04-21 15:35:29');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `rental_photos`
--

CREATE TABLE `rental_photos` (
  `rental_photo_id` bigint(20) UNSIGNED NOT NULL,
  `rental_id` bigint(20) UNSIGNED NOT NULL,
  `uploader_user_id` bigint(20) UNSIGNED NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `photo_type` enum('pickup_user','pickup_rentalagent','return_user','return_rentalagent','damage_report') NOT NULL,
  `upload_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `reviews`
--

CREATE TABLE `reviews` (
  `review_id` bigint(20) UNSIGNED NOT NULL,
  `rental_id` bigint(20) UNSIGNED NOT NULL,
  `reviewer_user_id` bigint(20) UNSIGNED NOT NULL,
  `reviewed_user_id` bigint(20) UNSIGNED NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` text DEFAULT NULL,
  `review_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `date_of_birth` date NOT NULL,
  `driving_license_number` varchar(255) NOT NULL,
  `role` enum('admin','rentalagent','user') NOT NULL DEFAULT 'user',
  `user_status` enum('active','inactive','suspended') NOT NULL DEFAULT 'active',
  `is_approved` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password_hash`, `first_name`, `last_name`, `date_of_birth`, `driving_license_number`, `role`, `user_status`, `is_approved`, `created_at`, `updated_at`) VALUES
(1, 'admin_pali', 'admin@car.hu', 'hash', 'Pál', 'Admin', '1980-01-01', 'ADMIN01', 'admin', 'active', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(2, 'agent_fecó', 'feco@agent.hu', 'hash', 'Ferenc', 'Kovács', '1985-03-12', 'AG001', 'rentalagent', 'active', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(3, 'agent_zsuzsi', 'zsuzsi@agent.hu', 'hash', 'Zsuzsanna', 'Nagy', '1992-07-25', 'AG002', 'rentalagent', 'active', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(4, 'agent_tomi', 'tomi@agent.hu', 'hash', 'Tamás', 'Szabó', '1988-11-05', 'AG003', 'rentalagent', 'active', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(5, 'vigh_janos', 'janos@mail.hu', 'hash', 'János', 'Vígh', '1995-02-10', 'U001', 'user', 'active', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(6, 'kiss_kati', 'kati@mail.hu', 'hash', 'Katalin', 'Kiss', '1998-05-15', 'U002', 'user', 'active', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(7, 'toth_bela', 'bela@mail.hu', 'hash', 'Béla', 'Tóth', '1990-08-20', 'U003', 'user', 'active', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(8, 'nemeth_eva', 'eva@mail.hu', 'hash', 'Éva', 'Németh', '2001-12-01', 'U004', 'user', 'active', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(9, 'varga_adam', 'adam@mail.hu', 'hash', 'Ádám', 'Varga', '1994-04-30', 'U005', 'user', 'active', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `vehicles`
--

CREATE TABLE `vehicles` (
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `rentalagent_id` bigint(20) UNSIGNED NOT NULL,
  `brand` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `year` year(4) NOT NULL,
  `license_plate` varchar(10) NOT NULL,
  `daily_rate` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `fuel_type` enum('petrol','diesel','electric','hybrid') NOT NULL,
  `transmission_type` enum('manual','automatic') NOT NULL,
  `number_of_seats` int(11) NOT NULL,
  `location_pickup` varchar(100) NOT NULL,
  `location_return` varchar(100) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT 1,
  `upload_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_approved` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `vehicles`
--

INSERT INTO `vehicles` (`vehicle_id`, `rentalagent_id`, `brand`, `model`, `year`, `license_plate`, `daily_rate`, `description`, `fuel_type`, `transmission_type`, `number_of_seats`, `location_pickup`, `location_return`, `is_available`, `upload_date`, `is_approved`, `created_at`, `updated_at`) VALUES
(1, 2, 'Skoda', 'Octavia', '2021', 'ABC-123', 15000.00, NULL, 'diesel', 'manual', 5, 'Budapest', 'Budapest', 1, '2026-04-21 15:35:29', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(2, 2, 'Volkswagen', 'Golf', '2020', 'VW-100', 12000.00, NULL, 'petrol', 'manual', 5, 'Budapest', 'Budapest', 1, '2026-04-21 15:35:29', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(3, 2, 'Tesla', 'Model 3', '2023', 'ELC-001', 35000.00, NULL, 'electric', 'automatic', 5, 'Budaörs', 'Budaörs', 1, '2026-04-21 15:35:29', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(4, 3, 'Toyota', 'Corolla', '2022', 'TYT-555', 18000.00, NULL, 'hybrid', 'automatic', 5, 'Debrecen', 'Debrecen', 1, '2026-04-21 15:35:29', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(5, 3, 'Ford', 'Focus', '2019', 'FRD-888', 11000.00, NULL, 'petrol', 'manual', 5, 'Debrecen', 'Debrecen', 1, '2026-04-21 15:35:29', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(6, 4, 'BMW', 'X5', '2022', 'BMW-999', 45000.00, NULL, 'diesel', 'automatic', 5, 'Szeged', 'Szeged', 1, '2026-04-21 15:35:29', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(7, 4, 'Audi', 'A4', '2021', 'AUD-444', 22000.00, NULL, 'petrol', 'automatic', 5, 'Szeged', 'Szeged', 1, '2026-04-21 15:35:29', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29'),
(8, 4, 'Dacia', 'Duster', '2022', 'DAC-007', 9000.00, NULL, 'petrol', 'manual', 5, 'Szeged', 'Szeged', 1, '2026-04-21 15:35:29', 1, '2026-04-21 15:35:29', '2026-04-21 15:35:29');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `vehicle_images`
--

CREATE TABLE `vehicle_images` (
  `image_id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `rentalagent_applications`
--
ALTER TABLE `rentalagent_applications`
  ADD PRIMARY KEY (`application_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- A tábla indexei `rentals`
--
ALTER TABLE `rentals`
  ADD PRIMARY KEY (`rental_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `vehicle_id` (`vehicle_id`);

--
-- A tábla indexei `rental_photos`
--
ALTER TABLE `rental_photos`
  ADD PRIMARY KEY (`rental_photo_id`),
  ADD KEY `rental_id` (`rental_id`),
  ADD KEY `uploader_user_id` (`uploader_user_id`);

--
-- A tábla indexei `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD UNIQUE KEY `rental_id` (`rental_id`),
  ADD KEY `reviewer_user_id` (`reviewer_user_id`),
  ADD KEY `reviewed_user_id` (`reviewed_user_id`);

--
-- A tábla indexei `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `driving_license_number` (`driving_license_number`);

--
-- A tábla indexei `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`vehicle_id`),
  ADD UNIQUE KEY `license_plate` (`license_plate`),
  ADD KEY `rentalagent_id` (`rentalagent_id`);

--
-- A tábla indexei `vehicle_images`
--
ALTER TABLE `vehicle_images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `vehicle_id` (`vehicle_id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `rentalagent_applications`
--
ALTER TABLE `rentalagent_applications`
  MODIFY `application_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `rentals`
--
ALTER TABLE `rentals`
  MODIFY `rental_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `rental_photos`
--
ALTER TABLE `rental_photos`
  MODIFY `rental_photo_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT a táblához `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `vehicle_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT a táblához `vehicle_images`
--
ALTER TABLE `vehicle_images`
  MODIFY `image_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `rentalagent_applications`
--
ALTER TABLE `rentalagent_applications`
  ADD CONSTRAINT `rentalagent_applications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rentalagent_applications_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`);

--
-- Megkötések a táblához `rentals`
--
ALTER TABLE `rentals`
  ADD CONSTRAINT `rentals_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `rentals_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`);

--
-- Megkötések a táblához `rental_photos`
--
ALTER TABLE `rental_photos`
  ADD CONSTRAINT `rental_photos_ibfk_1` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rental_photos_ibfk_2` FOREIGN KEY (`uploader_user_id`) REFERENCES `users` (`user_id`);

--
-- Megkötések a táblához `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`rental_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`reviewer_user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`reviewed_user_id`) REFERENCES `users` (`user_id`);

--
-- Megkötések a táblához `sessions`
--
ALTER TABLE `sessions`
  ADD CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Megkötések a táblához `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`rentalagent_id`) REFERENCES `users` (`user_id`);

--
-- Megkötések a táblához `vehicle_images`
--
ALTER TABLE `vehicle_images`
  ADD CONSTRAINT `vehicle_images_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
