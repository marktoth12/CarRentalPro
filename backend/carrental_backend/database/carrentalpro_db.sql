-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: localhost
-- Létrehozás ideje: 2026. Ápr 23. 13:40
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
-- Tábla szerkezet ehhez a táblához `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_04_16_000001_create_vehicles_table', 1),
(5, '2026_04_16_000002_create_vehicle_images_table', 1),
(6, '2026_04_16_000003_create_rentals_table', 1),
(7, '2026_04_16_000004_create_rental_photos_table', 1),
(8, '2026_04_16_000005_create_reviews_table', 1),
(9, '2026_04_16_000007_create_rentalagent_applications_table', 1),
(10, '2019_12_14_000001_create_personal_access_tokens_table', 2);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 2, 'auth-token', 'bcf15ea8e06130afdabd4e5e3a7f785d5cc008285c33d392e3e245dc10136cc1', '[\"*\"]', NULL, NULL, '2026-04-21 18:51:40', '2026-04-21 18:51:40'),
(2, 'App\\Models\\User', 2, 'auth-token', '18a53f45d5fe6e9e241d5b2af6609a24f7002e088c99afdde9df9b7b4cab6048', '[\"*\"]', NULL, NULL, '2026-04-21 18:56:40', '2026-04-21 18:56:40'),
(3, 'App\\Models\\User', 2, 'auth-token', '580630159e5802e96c690cd3b513cee52061524ab14eded397155692d41c2490', '[\"*\"]', NULL, NULL, '2026-04-21 19:07:01', '2026-04-21 19:07:01'),
(4, 'App\\Models\\User', 2, 'auth-token', '7bb21dc03fdcd6e81b1ae4effb0fd78d076d7233a9b818b79d9b1a73b80fa35a', '[\"*\"]', NULL, NULL, '2026-04-21 19:08:48', '2026-04-21 19:08:48'),
(5, 'App\\Models\\User', 2, 'auth-token', '12ab1b5017d8058018453168bb5909e40d716d9090134c2d08c11fb1cd222b93', '[\"*\"]', '2026-04-21 19:17:01', NULL, '2026-04-21 19:14:47', '2026-04-21 19:17:01'),
(6, 'App\\Models\\User', 2, 'auth-token', 'ff171b749e5f047e1e36e062a2f6711561f84097248c31c4461378cd0dd09b87', '[\"*\"]', NULL, NULL, '2026-04-21 19:16:34', '2026-04-21 19:16:34'),
(7, 'App\\Models\\User', 2, 'auth-token', '86b913ba71c080a289aceec6ae3430099bf0c1a9df75ab49951fd35c69eb0b6d', '[\"*\"]', NULL, NULL, '2026-04-21 19:18:21', '2026-04-21 19:18:21'),
(8, 'App\\Models\\User', 2, 'auth-token', '7bee63626b6b4e150c8646affce833ad638c2371d87785c4169d559c6c561eb0', '[\"*\"]', '2026-04-21 19:21:02', NULL, '2026-04-21 19:19:58', '2026-04-21 19:21:02'),
(9, 'App\\Models\\User', 2, 'auth-token', '6c449e96fe87ff6f55ea42431dc3903c735cd7ec93d5ad9e20a301944cb50f31', '[\"*\"]', '2026-04-21 19:23:05', NULL, '2026-04-21 19:21:13', '2026-04-21 19:23:05'),
(10, 'App\\Models\\User', 2, 'auth-token', 'd05ff0e39c4c858c3106ba4b1aafd81721493138016605524042a9041f9cf460', '[\"*\"]', '2026-04-21 19:24:06', NULL, '2026-04-21 19:23:18', '2026-04-21 19:24:06'),
(11, 'App\\Models\\User', 2, 'auth-token', '1c6f26a539291293543b4464b1daa8f222ee87402dbd9170a60cc049d9932cdb', '[\"*\"]', '2026-04-21 19:26:38', NULL, '2026-04-21 19:24:29', '2026-04-21 19:26:38'),
(12, 'App\\Models\\User', 2, 'auth-token', 'bce358a05713e86da05c70fd818cc15bf6cd1ccd92bef395a53d9a70b2c1c111', '[\"*\"]', '2026-04-21 19:27:53', NULL, '2026-04-21 19:26:47', '2026-04-21 19:27:53'),
(13, 'App\\Models\\User', 2, 'auth-token', '0c9907c81bfa86589400148a060293747a450f9f73216f78047dd6f7c7984e48', '[\"*\"]', '2026-04-21 19:28:19', NULL, '2026-04-21 19:28:01', '2026-04-21 19:28:19'),
(14, 'App\\Models\\User', 2, 'auth-token', '4faa84786fe3b75a01bd46c50287c33378bd8660b38586157a72897a94e9607c', '[\"*\"]', '2026-04-21 19:29:42', NULL, '2026-04-21 19:28:29', '2026-04-21 19:29:42'),
(15, 'App\\Models\\User', 2, 'auth-token', '043098c59de42e7d9490d9d0c8164b0e0dae459769742ac1120ff248cb388617', '[\"*\"]', '2026-04-21 19:30:53', NULL, '2026-04-21 19:29:50', '2026-04-21 19:30:53'),
(16, 'App\\Models\\User', 2, 'auth-token', 'afa703ae141b04de090d40bc6003666416720f5dac95c46fa150fa867dd29320', '[\"*\"]', '2026-04-21 19:39:37', NULL, '2026-04-21 19:31:02', '2026-04-21 19:39:37'),
(17, 'App\\Models\\User', 2, 'auth-token', '8a29aa4521d508adcc6f07931d92e56e47f7b82120f84c8fa72f1efa17674227', '[\"*\"]', '2026-04-22 18:02:42', NULL, '2026-04-22 18:00:07', '2026-04-22 18:02:42'),
(18, 'App\\Models\\User', 1, 'auth-token', '717de35988a719837e8038dcd607cd4faa380574e5dcc99807917f1c654a4e53', '[\"*\"]', NULL, NULL, '2026-04-22 18:03:47', '2026-04-22 18:03:47'),
(19, 'App\\Models\\User', 2, 'auth-token', 'ac9d3f15ba7fe98e459b023b9e6c4c52d8d8f3eaac9d6ed0e744008aba816af4', '[\"*\"]', '2026-04-22 18:09:45', NULL, '2026-04-22 18:03:59', '2026-04-22 18:09:45'),
(20, 'App\\Models\\User', 5, 'auth-token', '436da11fb0af0c5a7d3d3965dd90009fee8e76c7dc9e3d40cb26c46d95d8a0db', '[\"*\"]', '2026-04-22 18:10:48', NULL, '2026-04-22 18:10:46', '2026-04-22 18:10:48'),
(21, 'App\\Models\\User', 4, 'auth-token', '5ed12d63704c5f9f847807af0f7f250389dde67e19d45a844091854201605455', '[\"*\"]', '2026-04-22 18:17:00', NULL, '2026-04-22 18:11:16', '2026-04-22 18:17:00'),
(22, 'App\\Models\\User', 2, 'auth-token', '14e035aca8b0d503a2674a55e3fd45100c747204ac89b7c7259cdedaedb9b9df', '[\"*\"]', '2026-04-22 18:29:13', NULL, '2026-04-22 18:18:19', '2026-04-22 18:29:13'),
(23, 'App\\Models\\User', 3, 'auth-token', '494ca4ff88adb640bec7b1a69dd0ea07755a5024302e6af510100912545ba582', '[\"*\"]', '2026-04-22 18:30:29', NULL, '2026-04-22 18:29:42', '2026-04-22 18:30:29'),
(24, 'App\\Models\\User', 4, 'auth-token', 'db688bb917ad597b6f2728dbcf25843c2af9c06ba4af23986d3c12f96135f2cb', '[\"*\"]', '2026-04-23 05:28:53', NULL, '2026-04-22 18:30:57', '2026-04-23 05:28:53'),
(25, 'App\\Models\\User', 1, 'auth-token', '0aa74faf179b64dfef6e1b007324213adbc70963ab2c2acce2296f543e6643dd', '[\"*\"]', '2026-04-23 06:09:10', NULL, '2026-04-23 05:31:32', '2026-04-23 06:09:10'),
(26, 'App\\Models\\User', 4, 'auth-token', '907f7fb4d27969fe914053bfa7f70e5e2aee9e5c32977ca58c897e8081826180', '[\"*\"]', '2026-04-23 06:10:19', NULL, '2026-04-23 06:09:34', '2026-04-23 06:10:19'),
(27, 'App\\Models\\User', 1, 'auth-token', '21b87d4c0b4c5a43fc33e521709d0153d5790fd3614abba193ccb256cf04bf55', '[\"*\"]', '2026-04-23 06:11:04', NULL, '2026-04-23 06:10:55', '2026-04-23 06:11:04'),
(28, 'App\\Models\\User', 4, 'auth-token', '1e9ca451e753c8277a338a8de96720ea68408c6bfc0887ba37e4108c6c2aefb7', '[\"*\"]', '2026-04-23 06:31:05', NULL, '2026-04-23 06:30:55', '2026-04-23 06:31:05'),
(29, 'App\\Models\\User', 1, 'auth-token', '3640e8a82380a9136c28678942715bbaf51c4138877a8e581393c092cd1f7e02', '[\"*\"]', '2026-04-23 07:04:40', NULL, '2026-04-23 06:34:21', '2026-04-23 07:04:40'),
(30, 'App\\Models\\User', 4, 'auth-token', '75226a8e78c3aede5af784b369b0b7ff24bf169604625a06f4858724c379ade0', '[\"*\"]', '2026-04-23 07:05:32', NULL, '2026-04-23 07:05:16', '2026-04-23 07:05:32'),
(31, 'App\\Models\\User', 1, 'auth-token', '1cf8e77ea0fdb7d4f1e34b74a400e0b0d7911f9ac00e16f66f019c840b51ccff', '[\"*\"]', '2026-04-23 07:26:36', NULL, '2026-04-23 07:26:35', '2026-04-23 07:26:36'),
(32, 'App\\Models\\User', 10, 'auth-token', 'd95e3253117460930a83af16580cd53944889200e947195cfd6944552a32ed93', '[\"*\"]', NULL, NULL, '2026-04-23 07:28:11', '2026-04-23 07:28:11'),
(33, 'App\\Models\\User', 10, 'auth-token', 'de748a9cf86114872867bb0ad700b2ea5ad3a0422f24e20a44f44ac07daad6f7', '[\"*\"]', '2026-04-23 07:28:36', NULL, '2026-04-23 07:28:28', '2026-04-23 07:28:36'),
(34, 'App\\Models\\User', 11, 'auth-token', '815f4e59bc7b85450ab918ee37ec273cd55a9a8322abd4707e58bcf0536f8437', '[\"*\"]', '2026-04-23 07:29:12', NULL, '2026-04-23 07:29:12', '2026-04-23 07:29:12'),
(35, 'App\\Models\\User', 1, 'auth-token', '7b775c9287030df3768abb355d836e282e2d1a598a7c87136bcd3bdb0cfbb967', '[\"*\"]', '2026-04-23 07:29:23', NULL, '2026-04-23 07:29:22', '2026-04-23 07:29:23'),
(36, 'App\\Models\\User', 11, 'auth-token', '9b56f042e3fb77ac69307c13332a808d99c1acfe63a38c265022eb3b126d2c2e', '[\"*\"]', '2026-04-23 07:30:29', NULL, '2026-04-23 07:29:48', '2026-04-23 07:30:29'),
(37, 'App\\Models\\User', 1, 'auth-token', 'd91fd0b9b269f708b9ca89645511fb990f2f890e08d9a45aed1c8aa9d329bec8', '[\"*\"]', '2026-04-23 07:32:22', NULL, '2026-04-23 07:31:33', '2026-04-23 07:32:22'),
(38, 'App\\Models\\User', 11, 'auth-token', '4c76cc041153fd8773777ea42cd1853ee2fcac09be4a2e36c9ba36bc1d7cfdd8', '[\"*\"]', '2026-04-23 07:32:39', NULL, '2026-04-23 07:32:38', '2026-04-23 07:32:39'),
(39, 'App\\Models\\User', 11, 'auth-token', '6b69cfcadabaee1459560c3f9303c8a4e2d65c64765733903bd33cd878f81aa3', '[\"*\"]', '2026-04-23 08:10:09', NULL, '2026-04-23 08:10:08', '2026-04-23 08:10:09'),
(40, 'App\\Models\\User', 1, 'auth-token', '1d859b3ecfcc4bbf40372a767981a677de786ac0d10129f4413e96b98757a34d', '[\"*\"]', '2026-04-23 08:22:33', NULL, '2026-04-23 08:22:32', '2026-04-23 08:22:33'),
(41, 'App\\Models\\User', 11, 'auth-token', 'ae1a578fe71a50e0a7ee998f93ab2fa80d294d625c48991a66a444b65c6c28ec', '[\"*\"]', '2026-04-23 08:40:55', NULL, '2026-04-23 08:40:43', '2026-04-23 08:40:55'),
(42, 'App\\Models\\User', 1, 'auth-token', 'f0808a849e0377ad19f7fa82a898642911f1c3cb6e49772481bb04e315db9b96', '[\"*\"]', '2026-04-23 08:41:04', NULL, '2026-04-23 08:41:03', '2026-04-23 08:41:04'),
(43, 'App\\Models\\User', 10, 'auth-token', '7366a1c50734b586e904568b123ccf42124e26951e0b74ca27c270e5d9268531', '[\"*\"]', NULL, NULL, '2026-04-23 08:41:44', '2026-04-23 08:41:44'),
(44, 'App\\Models\\User', 11, 'auth-token', '55604b7a26081b7dc7457dc7d68a35364675209aed4048769a85e3d8869171c9', '[\"*\"]', '2026-04-23 08:44:26', NULL, '2026-04-23 08:41:59', '2026-04-23 08:44:26'),
(45, 'App\\Models\\User', 7, 'auth-token', 'cd3f7474d9b1608a81a2bffa9122bb5d02c40576b4284d20e0937386d4a7cc24', '[\"*\"]', '2026-04-23 08:49:49', NULL, '2026-04-23 08:44:59', '2026-04-23 08:49:49'),
(46, 'App\\Models\\User', 11, 'auth-token', 'ba0c7d47441d43fd79498dfbf8ec847206dab445f846b9cd76d0930a53003344', '[\"*\"]', '2026-04-23 09:08:21', NULL, '2026-04-23 09:07:03', '2026-04-23 09:08:21'),
(47, 'App\\Models\\User', 1, 'auth-token', 'e420db814811a72a0d251817abee806e81fce2513743af00826d123d444ae68e', '[\"*\"]', '2026-04-23 09:28:43', NULL, '2026-04-23 09:08:32', '2026-04-23 09:28:43'),
(48, 'App\\Models\\User', 1, 'auth-token', '0818f59fa6b4a8bde7fa64eb4f1b3be1b20c7fab00cac63b72db6953ca69a043', '[\"*\"]', '2026-04-23 09:09:53', NULL, '2026-04-23 09:09:26', '2026-04-23 09:09:53'),
(49, 'App\\Models\\User', 11, 'auth-token', '89aaf4e6dcdd56843869d66eb2c3c42f0695fbeec09c49a4ace1cd8ce0ec8b7d', '[\"*\"]', '2026-04-23 09:29:22', NULL, '2026-04-23 09:29:08', '2026-04-23 09:29:22'),
(50, 'App\\Models\\User', 2, 'auth-token', '5496d6869541bb2b7e459275d1ec6cc4d1207e0ece1332438a3a2790c3da43eb', '[\"*\"]', '2026-04-23 09:30:52', NULL, '2026-04-23 09:29:44', '2026-04-23 09:30:52'),
(51, 'App\\Models\\User', 11, 'auth-token', '0287367919180c55cb3d2e362edb36c8da81c104b01f094416088e9376d64c75', '[\"*\"]', '2026-04-23 09:35:53', NULL, '2026-04-23 09:35:52', '2026-04-23 09:35:53');

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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `rentalagent_applications`
--

INSERT INTO `rentalagent_applications` (`application_id`, `user_id`, `application_date`, `status`, `admin_id`, `decision_date`, `created_at`, `updated_at`) VALUES
(1, 11, '2026-04-23 09:29:12', 'approved', 1, '2026-04-23 09:32:22', '2026-04-23 07:29:12', '2026-04-23 07:32:22');

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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `rentals`
--

INSERT INTO `rentals` (`rental_id`, `user_id`, `vehicle_id`, `start_date`, `end_date`, `actual_return_date`, `pickup_location`, `return_location`, `total_price`, `rental_status`, `rental_request_date`, `rentalagent_decision_date`, `created_at`, `updated_at`) VALUES
(3, 7, 6, '2026-04-21 09:00:00', '2026-04-22 09:00:00', NULL, 'Szeged', 'Szeged', 180000.00, 'pending_approval', '2026-04-21 20:41:13', '2026-04-23 07:23:56', NULL, '2026-04-23 05:23:56'),
(5, 1, 7, '2026-04-24 00:00:00', '2026-04-25 00:00:00', NULL, 'Szeged', 'Szeged', 22000.00, 'approved', '2026-04-23 09:04:38', '2026-04-23 09:05:32', '2026-04-23 07:04:38', '2026-04-23 07:05:32'),
(6, 2, 3, '2026-04-23 00:00:00', '2026-04-30 00:00:00', NULL, 'Budaörs', 'Budaörs', 245000.00, 'approved', '2026-04-23 11:30:25', '2026-04-23 11:30:47', '2026-04-23 09:30:25', '2026-04-23 09:30:47');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password_hash`, `first_name`, `last_name`, `date_of_birth`, `driving_license_number`, `role`, `user_status`, `is_approved`, `created_at`, `updated_at`) VALUES
(1, 'admin_pali', 'admin@car.hu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Pál', 'Admin', '1980-01-01', 'ADMIN01', 'admin', 'active', 1, NULL, NULL),
(2, 'agent_fecó', 'feco@agent.hu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ferenc', 'Kovács', '1985-03-12', 'AG001', 'rentalagent', 'active', 1, NULL, NULL),
(3, 'agent_zsuzsi', 'zsuzsi@agent.hu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Zsuzsanna', 'Nagy', '1992-07-25', 'AG002', 'rentalagent', 'active', 1, NULL, NULL),
(4, 'agent_tomi', 'tomi@agent.hu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tamás', 'Szabó', '1988-11-05', 'AG003', 'rentalagent', 'active', 1, NULL, NULL),
(5, 'vigh_janos', 'janos@mail.hu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'János', 'Vígh', '1995-02-10', 'U001', 'user', 'active', 1, NULL, NULL),
(6, 'kiss_kati', 'kati@mail.hu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Katalin', 'Kiss', '1998-05-15', 'U002', 'user', 'active', 1, NULL, NULL),
(7, 'toth_bela', 'bela@mail.hu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Béla', 'Tóth', '1990-08-20', 'U003', 'user', 'active', 1, NULL, NULL),
(8, 'nemeth_eva', 'eva@mail.hu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Éva', 'Németh', '2001-12-01', 'U004', 'user', 'active', 1, NULL, NULL),
(10, 'Teszt', 'teszt@gmail.com', '$2y$12$sDAp6DGAdXZENQuppXpwCeIi6idqhGNuZ0RjpV4madfYtKFSIdlJq', 'Teszt', 'Teszt', '2026-04-01', 'AB13232', 'user', 'active', 0, '2026-04-23 07:28:11', '2026-04-23 07:28:11'),
(11, 'berbadoteszt', 'tesztagent@gmail.com', '$2y$12$AH6/sGVvo3.d3MC21bk/UuBWf/foacLZkizUmUoK9wm/q96g9BcPe', 'Tesyt', 'Berbado', '2026-05-08', 'AB214123', 'rentalagent', 'active', 0, '2026-04-23 07:29:12', '2026-04-23 07:32:22');

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
  `is_approved` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `vehicles`
--

INSERT INTO `vehicles` (`vehicle_id`, `rentalagent_id`, `brand`, `model`, `year`, `license_plate`, `daily_rate`, `description`, `fuel_type`, `transmission_type`, `number_of_seats`, `location_pickup`, `location_return`, `is_available`, `is_approved`, `created_at`, `updated_at`) VALUES
(2, 2, 'Volkswagen', 'Golf', '2020', 'VW-100', 12000.00, NULL, 'petrol', 'manual', 5, 'Budapest', 'Budapest', 1, 1, NULL, '2026-04-23 06:02:53'),
(3, 2, 'Tesla', 'Model 3', '2023', 'ELC-001', 35000.00, NULL, 'electric', 'automatic', 5, 'Budaörs', 'Budaörs', 0, 1, NULL, '2026-04-23 09:30:47'),
(5, 3, 'Ford', 'Focus', '2019', 'FRD-888', 11000.00, NULL, 'petrol', 'manual', 5, 'Debrecen', 'Debrecen', 1, 1, NULL, NULL),
(6, 4, 'BMW', 'X5', '2022', 'BMW-999', 45000.00, NULL, 'diesel', 'automatic', 5, 'Szeged', 'Szeged', 0, 1, NULL, '2026-04-23 05:23:56'),
(7, 4, 'Audi', 'A4', '2021', 'AUD-444', 22000.00, NULL, 'petrol', 'automatic', 5, 'Szeged', 'Szeged', 0, 1, NULL, '2026-04-23 07:05:32'),
(8, 4, 'Dacia', 'Duster', '2022', 'DAC-007', 9000.00, NULL, 'petrol', 'manual', 5, 'Szeged', 'Szeged', 1, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `vehicle_images`
--

CREATE TABLE `vehicle_images` (
  `image_id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `vehicle_images`
--

INSERT INTO `vehicle_images` (`image_id`, `vehicle_id`, `image_url`, `description`, `created_at`, `updated_at`) VALUES
(34, 2, 'https://kocsi-media.hu/1434/volkswagen-golf-viii-1-5-tsi-life-allwetter-kamera-acc-460466_1002344_1xl.jpg', 'Volkswagen Golf elolrol', NULL, NULL),
(35, 2, 'https://kocsi-media.hu/1434/volkswagen-golf-viii-1-5-tsi-life-allwetter-kamera-acc-224200_1002344_2xl.jpg', 'Volkswagen Golf oldal', NULL, NULL),
(36, 3, 'https://prod.pictures.autoscout24.net/listing-images/303d3835-2cfd-4493-bfa4-0255e307a26a_572a0a85-db32-4a43-b261-95a0525012de.jpg/1920x1080.webp', 'Tesla Model 3 elolrol', NULL, NULL),
(37, 3, 'https://prod.pictures.autoscout24.net/listing-images/303d3835-2cfd-4493-bfa4-0255e307a26a_ec75a7d7-bd1c-4873-bcb5-234442f956c2.jpg/1920x1080.webp', 'Tesla Model 3 oldal', NULL, NULL),
(38, 5, 'https://prod.pictures.autoscout24.net/listing-images/6c88e59b-bc75-4a77-9e45-457ec9ae4fe9_39e0b5e8-04ab-480c-b403-850c1b0e7ebd.jpg/1920x1080.webp', 'Ford Focus elolrol', NULL, NULL),
(39, 5, 'https://prod.pictures.autoscout24.net/listing-images/6c88e59b-bc75-4a77-9e45-457ec9ae4fe9_275a5c4d-af3c-4d74-baf9-0a40bda19704.jpg/1920x1080.webp', 'Ford Focus oldal', NULL, NULL),
(40, 6, 'https://prod.pictures.autoscout24.net/listing-images/cad80eba-9e6b-41ea-94b7-c107ad6be73b_e057a7b8-2518-41f6-985f-70ae5837f678.jpg/1920x1080.webp', 'BMW X5 elolrol', NULL, NULL),
(41, 6, 'https://prod.pictures.autoscout24.net/listing-images/cad80eba-9e6b-41ea-94b7-c107ad6be73b_72bec781-8e0f-4256-8d57-63648ca7d16d.jpg/1920x1080.webp', 'BMW X5 oldal', NULL, NULL),
(42, 7, 'https://prod.pictures.autoscout24.net/listing-images/056858ab-c39c-40cc-a74a-4707537de035_7a747686-739c-436b-b4b6-5f8c9c770120.jpg/720x540.webp', 'Audi A4 elolrol', NULL, NULL),
(43, 7, 'https://prod.pictures.autoscout24.net/listing-images/056858ab-c39c-40cc-a74a-4707537de035_c358ba07-c4e5-4210-9744-3cb42421372e.jpg/720x540.webp', 'Audi A4 oldal', NULL, NULL),
(44, 8, 'https://prod.pictures.autoscout24.net/listing-images/75419b8f-a747-44cf-94da-a49be8c3fae6_17a42e23-0d71-44a9-a339-129c38ddcca0.jpg/720x540.webp', 'Dacia Duster elolrol', NULL, NULL),
(45, 8, 'https://prod.pictures.autoscout24.net/listing-images/75419b8f-a747-44cf-94da-a49be8c3fae6_fabcbcb1-8911-4f7b-9dfb-e6e58b7ad6f0.jpg/720x540.webp', 'Dacia Duster oldal', NULL, NULL);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `vehicle_messages`
--

CREATE TABLE `vehicle_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `sender_id` bigint(20) UNSIGNED NOT NULL,
  `rentalagent_id` bigint(20) UNSIGNED NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- A tábla indexei `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- A tábla indexei `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- A tábla indexei `rentalagent_applications`
--
ALTER TABLE `rentalagent_applications`
  ADD PRIMARY KEY (`application_id`),
  ADD UNIQUE KEY `rentalagent_applications_user_id_unique` (`user_id`),
  ADD KEY `rentalagent_applications_admin_id_foreign` (`admin_id`);

--
-- A tábla indexei `rentals`
--
ALTER TABLE `rentals`
  ADD PRIMARY KEY (`rental_id`),
  ADD KEY `rentals_user_id_foreign` (`user_id`),
  ADD KEY `rentals_vehicle_id_foreign` (`vehicle_id`);

--
-- A tábla indexei `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_foreign` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_driving_license_number_unique` (`driving_license_number`);

--
-- A tábla indexei `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`vehicle_id`),
  ADD UNIQUE KEY `vehicles_license_plate_unique` (`license_plate`),
  ADD KEY `vehicles_rentalagent_id_foreign` (`rentalagent_id`);

--
-- A tábla indexei `vehicle_images`
--
ALTER TABLE `vehicle_images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `vehicle_images_vehicle_id_foreign` (`vehicle_id`);

--
-- A tábla indexei `vehicle_messages`
--
ALTER TABLE `vehicle_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `rentalagent_id` (`rentalagent_id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT a táblához `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT a táblához `rentalagent_applications`
--
ALTER TABLE `rentalagent_applications`
  MODIFY `application_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT a táblához `rentals`
--
ALTER TABLE `rentals`
  MODIFY `rental_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT a táblához `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `vehicle_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT a táblához `vehicle_images`
--
ALTER TABLE `vehicle_images`
  MODIFY `image_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT a táblához `vehicle_messages`
--
ALTER TABLE `vehicle_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `rentalagent_applications`
--
ALTER TABLE `rentalagent_applications`
  ADD CONSTRAINT `rentalagent_applications_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `rentalagent_applications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `rentals`
--
ALTER TABLE `rentals`
  ADD CONSTRAINT `rentals_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `rentals_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`);

--
-- Megkötések a táblához `sessions`
--
ALTER TABLE `sessions`
  ADD CONSTRAINT `sessions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Megkötések a táblához `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `vehicles_rentalagent_id_foreign` FOREIGN KEY (`rentalagent_id`) REFERENCES `users` (`user_id`);

--
-- Megkötések a táblához `vehicle_images`
--
ALTER TABLE `vehicle_images`
  ADD CONSTRAINT `vehicle_images_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `vehicle_messages`
--
ALTER TABLE `vehicle_messages`
  ADD CONSTRAINT `vehicle_messages_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `vehicle_messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `vehicle_messages_ibfk_3` FOREIGN KEY (`rentalagent_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
