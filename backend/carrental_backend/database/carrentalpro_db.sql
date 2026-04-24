-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: localhost
-- Létrehozás ideje: 2026. Ápr 24. 16:29
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

--
-- A tábla adatainak kiíratása `contact_messages`
--

INSERT INTO `contact_messages` (`id`, `first_name`, `last_name`, `email`, `message`, `is_read`, `created_at`, `updated_at`) VALUES
(2, 'Tóth', 'Márk', 'toth@gmail.com', 'Kibéreltem egy autót, viszont a megbeszélt helyszínre nem azt az autót hozta el a bérbeadó!!! Segítsenek....', 0, '2026-04-24 12:04:16', '2026-04-24 12:04:16');

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
(51, 'App\\Models\\User', 11, 'auth-token', '0287367919180c55cb3d2e362edb36c8da81c104b01f094416088e9376d64c75', '[\"*\"]', '2026-04-23 09:35:53', NULL, '2026-04-23 09:35:52', '2026-04-23 09:35:53'),
(52, 'App\\Models\\User', 12, 'auth-token', '69e767164c0e0d2e3a9727b8c26aba75d87fda4cd52965ee060cddddf96efbae', '[\"*\"]', '2026-04-23 10:03:02', NULL, '2026-04-23 10:03:02', '2026-04-23 10:03:02'),
(53, 'App\\Models\\User', 1, 'auth-token', '9ba2ac89033156415d57e1a20510bb95de93e8d1d9f7a67ea8a41058bf317e16', '[\"*\"]', '2026-04-23 10:48:07', NULL, '2026-04-23 10:03:28', '2026-04-23 10:48:07'),
(54, 'App\\Models\\User', 2, 'auth-token', '8c3bae550141ef00ccd135504163139b8ff2e0a926705f984ef6aa7e73698085', '[\"*\"]', '2026-04-23 10:50:53', NULL, '2026-04-23 10:48:35', '2026-04-23 10:50:53'),
(55, 'App\\Models\\User', 1, 'auth-token', 'f37b759c9da28f72c199be931811f41ba66c489a250375f859a7ddc53701f906', '[\"*\"]', '2026-04-23 10:57:09', NULL, '2026-04-23 10:56:41', '2026-04-23 10:57:09'),
(56, 'App\\Models\\User', 12, 'auth-token', 'f961cc1882d345fa4f824285be752cdd95843710731154a34179ffc61a572e90', '[\"*\"]', '2026-04-23 10:58:03', NULL, '2026-04-23 10:57:22', '2026-04-23 10:58:03'),
(57, 'App\\Models\\User', 1, 'auth-token', 'b3a82198a8283e73f693516937ea3b0fd9a3bff7b1207bb639f07340416112ef', '[\"*\"]', '2026-04-23 10:58:57', NULL, '2026-04-23 10:58:18', '2026-04-23 10:58:57'),
(58, 'App\\Models\\User', 12, 'auth-token', 'bc4d7eab7f5d8a85f3fb1a8b85fd54daede3e02a98889ff1704ad8263d062a31', '[\"*\"]', '2026-04-23 11:22:54', NULL, '2026-04-23 10:59:06', '2026-04-23 11:22:54'),
(59, 'App\\Models\\User', 1, 'auth-token', 'c7d40524b2fabf9aebd31eb6a9b9a75fd4bb62828e9e7ff4f49a29401e936a75', '[\"*\"]', '2026-04-23 11:29:03', NULL, '2026-04-23 11:24:17', '2026-04-23 11:29:03'),
(60, 'App\\Models\\User', 2, 'auth-token', '8f696ba8ddbe2edc80e3544678e766760020dd514450074a0791a6388796a097', '[\"*\"]', '2026-04-23 11:29:29', NULL, '2026-04-23 11:29:23', '2026-04-23 11:29:29'),
(61, 'App\\Models\\User', 1, 'auth-token', '6141d00b6c6ec3a6d619873bda5a53fa06ed94f135a55e263c0bfd64915560b9', '[\"*\"]', '2026-04-23 11:33:23', NULL, '2026-04-23 11:29:52', '2026-04-23 11:33:23'),
(62, 'App\\Models\\User', 10, 'auth-token', '99748be324e11b5183b3f15a8be7e552a869864ff39b2dd5781e36329ed8e7db', '[\"*\"]', '2026-04-23 13:27:22', NULL, '2026-04-23 11:34:17', '2026-04-23 13:27:22'),
(63, 'App\\Models\\User', 1, 'auth-token', 'db7e552b9b90dc50b32344b1f91616c7a0daaff58101ef832d7eff27a799a9f3', '[\"*\"]', '2026-04-23 13:28:57', NULL, '2026-04-23 13:28:56', '2026-04-23 13:28:57'),
(64, 'App\\Models\\User', 12, 'auth-token', 'cfe30bff2f68f9d15a752ab805df4a9e2d554e82fd804c5d0cf9e57d4ebf8309', '[\"*\"]', '2026-04-23 13:31:11', NULL, '2026-04-23 13:30:39', '2026-04-23 13:31:11'),
(65, 'App\\Models\\User', 3, 'auth-token', '893763733154e8d79bc2397716e3f9564ce407ee33c8bf60e5820aa60bb376b8', '[\"*\"]', '2026-04-23 13:32:09', NULL, '2026-04-23 13:31:52', '2026-04-23 13:32:09'),
(66, 'App\\Models\\User', 12, 'auth-token', '97690756b9f511b466c2049058883a96ad6852a53d1e895f7a87ce819ab0c810', '[\"*\"]', '2026-04-23 13:33:07', NULL, '2026-04-23 13:32:23', '2026-04-23 13:33:07'),
(67, 'App\\Models\\User', 5, 'auth-token', '2b03c66df19fc376faec0b2d6d75aac6ecc2dda7efddf07dcb32eb0cf05b1454', '[\"*\"]', '2026-04-23 13:35:48', NULL, '2026-04-23 13:35:46', '2026-04-23 13:35:48'),
(68, 'App\\Models\\User', 6, 'auth-token', '1a4036f6616fb7d7dd6ded3c2a8144ae5b5d429b1a988de041eabb0c523681d0', '[\"*\"]', '2026-04-23 13:36:08', NULL, '2026-04-23 13:36:06', '2026-04-23 13:36:08'),
(69, 'App\\Models\\User', 10, 'auth-token', '243b8cea33f023353c0467daf837f505a61cbf85f1ca2a9780ee622b3310734f', '[\"*\"]', '2026-04-23 13:39:18', NULL, '2026-04-23 13:36:38', '2026-04-23 13:39:18'),
(70, 'App\\Models\\User', 12, 'auth-token', '145fbe5407f80860349fde2a2d0f991129be17565bdc40abd39a7573f902e937', '[\"*\"]', '2026-04-23 13:40:17', NULL, '2026-04-23 13:39:28', '2026-04-23 13:40:17'),
(71, 'App\\Models\\User', 1, 'auth-token', 'adc73ecdbd79455febd5d6275eb90097b09a72d66491eba570d85f87d91eb439', '[\"*\"]', '2026-04-23 13:42:44', NULL, '2026-04-23 13:42:29', '2026-04-23 13:42:44'),
(72, 'App\\Models\\User', 1, 'auth-token', 'e5acb5b56d22e25bc8bc0780b0f8657f2d071953431f0422f80c6ebcea220318', '[\"*\"]', '2026-04-23 13:47:10', NULL, '2026-04-23 13:47:09', '2026-04-23 13:47:10'),
(73, 'App\\Models\\User', 12, 'auth-token', 'a2ff360ed9a05367fc06ee094ceb39835ac43799d6f1648f0c45b959fa242f70', '[\"*\"]', '2026-04-23 13:47:56', NULL, '2026-04-23 13:47:26', '2026-04-23 13:47:56'),
(74, 'App\\Models\\User', 2, 'auth-token', '6e1408c1b2fee9edd42594cddb160d9e49c75cba52f84584e33890f2583f7e14', '[\"*\"]', '2026-04-23 13:48:34', NULL, '2026-04-23 13:48:21', '2026-04-23 13:48:34'),
(75, 'App\\Models\\User', 12, 'auth-token', 'd0c952d709d093cd33919eacfe41a5d39e6a26facc50697f8f43849320f14f67', '[\"*\"]', '2026-04-23 15:46:31', NULL, '2026-04-23 13:48:50', '2026-04-23 15:46:31'),
(76, 'App\\Models\\User', 4, 'auth-token', 'b8fa5643fc7cc87caab1e2b6df128874fdc86b0e8d1f96519bbb530586e0abdd', '[\"*\"]', '2026-04-23 15:49:32', NULL, '2026-04-23 15:47:22', '2026-04-23 15:49:32'),
(77, 'App\\Models\\User', 2, 'auth-token', 'f87693f841c5413fbea570f3314b68f843aec77d11cc2d3315b1a43f30d7815b', '[\"*\"]', '2026-04-23 15:49:51', NULL, '2026-04-23 15:49:50', '2026-04-23 15:49:51'),
(78, 'App\\Models\\User', 4, 'auth-token', '9c7d81ea75ab49d1e242f71e854a473d54693116a5fc363da21d5ab6c31ed6e6', '[\"*\"]', '2026-04-23 15:52:00', NULL, '2026-04-23 15:50:05', '2026-04-23 15:52:00'),
(79, 'App\\Models\\User', 2, 'auth-token', '23625540b3da5457d51d281aa96033d41785ad39952f2cfcdbe398d012946305', '[\"*\"]', '2026-04-23 15:52:31', NULL, '2026-04-23 15:52:10', '2026-04-23 15:52:31'),
(80, 'App\\Models\\User', 4, 'auth-token', '3ab91cee58269d86574a8881befcd819491a2f68bd43c621ae050960e2963df7', '[\"*\"]', '2026-04-23 15:53:07', NULL, '2026-04-23 15:53:02', '2026-04-23 15:53:07'),
(81, 'App\\Models\\User', 4, 'auth-token', '2ff0cb0060f5c5ef35dcfc5f294213a3a284077d4341aabb5436b40286be79b6', '[\"*\"]', '2026-04-23 15:59:17', NULL, '2026-04-23 15:56:23', '2026-04-23 15:59:17'),
(82, 'App\\Models\\User', 2, 'auth-token', '7075754f16c76bfb9e4eee82c3abbd19960a99d797451b3aa6c4eb9d30286d28', '[\"*\"]', '2026-04-23 16:09:32', NULL, '2026-04-23 16:04:00', '2026-04-23 16:09:32'),
(83, 'App\\Models\\User', 4, 'auth-token', '394bfe8a8f28c6384e84349f31daebb07fae7914432729da7de10ec3c3fe31c4', '[\"*\"]', '2026-04-23 16:09:49', NULL, '2026-04-23 16:09:45', '2026-04-23 16:09:49'),
(84, 'App\\Models\\User', 2, 'auth-token', '7154b07f9af9782c97117e595e75147ebdd9efff6313d412511e32cff33945e3', '[\"*\"]', '2026-04-23 16:20:24', NULL, '2026-04-23 16:10:20', '2026-04-23 16:20:24'),
(85, 'App\\Models\\User', 4, 'auth-token', 'bea92fa9c37abb1db7c3125d1fb8710ae8d1f1a43530fe04d7863600f1156442', '[\"*\"]', '2026-04-23 16:20:35', NULL, '2026-04-23 16:20:32', '2026-04-23 16:20:35'),
(86, 'App\\Models\\User', 1, 'auth-token', '3394673e0d2cc838b8a195d4a5c1aa0c039db446e74dc4f66282ca2ec90f77a1', '[\"*\"]', '2026-04-23 16:25:27', NULL, '2026-04-23 16:23:24', '2026-04-23 16:25:27'),
(87, 'App\\Models\\User', 13, 'auth-token', '0db8b1742b60be37dfbefbe9bba9bc7bbea7f2733842a3595611340e44a79dfe', '[\"*\"]', NULL, NULL, '2026-04-23 16:26:45', '2026-04-23 16:26:45'),
(88, 'App\\Models\\User', 13, 'auth-token', '72546470bb4adceea48e0cb1a71554e74a8fed0673d5863fda0411603033c4cf', '[\"*\"]', NULL, NULL, '2026-04-23 16:26:54', '2026-04-23 16:26:54'),
(89, 'App\\Models\\User', 13, 'auth-token', 'b586db611473d7ce97c8667afeb6c0d1a9ea2d34df7797ca770a81fda6af0d7d', '[\"*\"]', '2026-04-23 16:27:43', NULL, '2026-04-23 16:27:21', '2026-04-23 16:27:43'),
(90, 'App\\Models\\User', 2, 'auth-token', '3c76f082b773f9a5e246e63220d7c8438feb4e59ea2c2604f5b4ef931b588f77', '[\"*\"]', '2026-04-23 16:28:35', NULL, '2026-04-23 16:27:55', '2026-04-23 16:28:35'),
(91, 'App\\Models\\User', 2, 'auth-token', 'cb4894f6d1fea1b5ac4f6e1ef67d3bf6bc53c4807cbdbbb6af3d763ad5c53850', '[\"*\"]', '2026-04-23 16:28:54', NULL, '2026-04-23 16:28:53', '2026-04-23 16:28:54'),
(92, 'App\\Models\\User', 13, 'auth-token', 'd65d19f27589a0b388b5007428df6a9d73aa732e8daf54ad77dcbebeb03cebb6', '[\"*\"]', '2026-04-23 16:29:04', NULL, '2026-04-23 16:29:02', '2026-04-23 16:29:04'),
(93, 'App\\Models\\User', 2, 'auth-token', 'a31dce49a5750f654dacb36adf8c3db1d7a7ae56adeae3342fbe761bf8e052a1', '[\"*\"]', '2026-04-23 16:30:16', NULL, '2026-04-23 16:29:14', '2026-04-23 16:30:16'),
(94, 'App\\Models\\User', 1, 'auth-token', 'f0dc5e0aa525671519876ebf13508211c0b8869bee5eda35b12b15004bf636d7', '[\"*\"]', '2026-04-23 16:30:51', NULL, '2026-04-23 16:30:31', '2026-04-23 16:30:51'),
(95, 'App\\Models\\User', 1, 'auth-token', '9992e44d7a938d6c1e9c4193b51336c01e099df6a6c5cb9957e1522e9269a7be', '[\"*\"]', '2026-04-23 16:45:53', NULL, '2026-04-23 16:43:46', '2026-04-23 16:45:53'),
(96, 'App\\Models\\User', 14, 'auth-token', '57a4cf58da16801fb44091b5e7e6c3aa5caf4e0faccc663abe35a2ba4e9e5f54', '[\"*\"]', '2026-04-23 16:46:51', NULL, '2026-04-23 16:46:51', '2026-04-23 16:46:51'),
(97, 'App\\Models\\User', 1, 'auth-token', 'c26350c214aa75cc5cc3bb11b3c507bba74563e082311332e070dfa952866eb4', '[\"*\"]', '2026-04-23 16:48:43', NULL, '2026-04-23 16:46:59', '2026-04-23 16:48:43'),
(98, 'App\\Models\\User', 2, 'auth-token', 'bea5ed35cd422dac36a212aa496f21c84d0731abfb21ae67383cf83a7b8956ab', '[\"*\"]', '2026-04-23 16:52:46', NULL, '2026-04-23 16:49:39', '2026-04-23 16:52:46'),
(99, 'App\\Models\\User', 1, 'auth-token', '61d4ba3f9a04a063fd7873e29ef8bcd6a95c73862f0745da1b108076e0d99d71', '[\"*\"]', '2026-04-24 11:12:00', NULL, '2026-04-24 11:04:24', '2026-04-24 11:12:00'),
(100, 'App\\Models\\User', 1, 'auth-token', 'a8fae4205fb507d5b3da5d22e2582f8c54b17004dbfc7d5941345f8762e4c2bf', '[\"*\"]', '2026-04-24 12:01:52', NULL, '2026-04-24 12:01:51', '2026-04-24 12:01:52'),
(101, 'App\\Models\\User', 1, 'auth-token', '4d7c800f1b9841598d0d46f58aadb0f0492b404c17a0874f8f7761e0f0acc9d3', '[\"*\"]', '2026-04-24 12:11:07', NULL, '2026-04-24 12:04:26', '2026-04-24 12:11:07'),
(102, 'App\\Models\\User', 14, 'auth-token', 'd6a9f170fd643b37386ace03e76a3f1ee80d1e35001efad8136076e74813a9af', '[\"*\"]', '2026-04-24 12:11:48', NULL, '2026-04-24 12:11:48', '2026-04-24 12:11:48'),
(103, 'App\\Models\\User', 14, 'auth-token', '22a71828e2cb763a784b68c51acb752ab06f1550eea155a8d95aafe577006549', '[\"*\"]', NULL, NULL, '2026-04-24 12:11:56', '2026-04-24 12:11:56'),
(104, 'App\\Models\\User', 1, 'auth-token', '3b9b4f1819544b9e7f734cdf846eedf14da195293e9721ba03dfe46db4536206', '[\"*\"]', '2026-04-24 12:16:49', NULL, '2026-04-24 12:12:04', '2026-04-24 12:16:49'),
(105, 'App\\Models\\User', 2, 'auth-token', 'fbf1ddee3329e628f559d75fcbd0bae2cd4bd04c797403959ad98922e5b7ef6f', '[\"*\"]', '2026-04-24 12:19:45', NULL, '2026-04-24 12:19:45', '2026-04-24 12:19:45'),
(106, 'App\\Models\\User', 13, 'auth-token', 'dcdbf8af33d7eb3b312422c14ddf9c3b334b9daf3bebf923766033f5da72ee9e', '[\"*\"]', '2026-04-24 12:20:27', NULL, '2026-04-24 12:20:16', '2026-04-24 12:20:27'),
(107, 'App\\Models\\User', 2, 'auth-token', '572bee9464f2a65160fa449d00b6f27ca8d0cfc7f7749528da5b0e670d6e5658', '[\"*\"]', '2026-04-24 12:20:38', NULL, '2026-04-24 12:20:37', '2026-04-24 12:20:38'),
(108, 'App\\Models\\User', 3, 'auth-token', 'a89c3f37c635b64f7cd94a5a0b33988f3d87b673717fc314ca2f4ccc86e761ee', '[\"*\"]', '2026-04-24 12:20:57', NULL, '2026-04-24 12:20:56', '2026-04-24 12:20:57'),
(109, 'App\\Models\\User', 14, 'auth-token', 'e944e8fb0feea03618712d6d316a75555c1244974d8e3a756047a00bb76f263d', '[\"*\"]', '2026-04-24 12:21:35', NULL, '2026-04-24 12:21:19', '2026-04-24 12:21:35'),
(110, 'App\\Models\\User', 5, 'auth-token', 'b3cb124b696abbfceb2190b02e1620281a23c85a6fadd399c9b11c5f5e4ef76a', '[\"*\"]', '2026-04-24 12:22:05', NULL, '2026-04-24 12:21:51', '2026-04-24 12:22:05'),
(111, 'App\\Models\\User', 5, 'auth-token', '16b865de68c80c0bc6dea3ef943f7579d08a8479d16a4ce051345f3c8cdd5e69', '[\"*\"]', '2026-04-24 12:22:18', NULL, '2026-04-24 12:22:16', '2026-04-24 12:22:18'),
(112, 'App\\Models\\User', 3, 'auth-token', '9fc93296a30db0e8028ef3b22f1daff9a6efe33092cf2e06bd707d49377edf64', '[\"*\"]', '2026-04-24 12:28:40', NULL, '2026-04-24 12:22:28', '2026-04-24 12:28:40');

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
(2, 14, '2026-04-24 14:11:48', 'pending', NULL, NULL, '2026-04-24 12:11:48', '2026-04-24 12:11:48');

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
(6, 2, 3, '2026-04-23 00:00:00', '2026-04-30 00:00:00', NULL, 'Budaörs', 'Budaörs', 245000.00, 'approved', '2026-04-23 11:30:25', '2026-04-23 11:30:47', '2026-04-23 09:30:25', '2026-04-23 09:30:47'),
(12, 4, 2, '2026-04-23 00:00:00', '2026-04-26 00:00:00', NULL, 'Budapest', 'Budapest', 36000.00, 'approved', '2026-04-23 17:49:28', '2026-04-23 18:20:24', '2026-04-23 15:49:28', '2026-04-23 16:20:24'),
(13, 4, 2, '2026-05-01 00:00:00', '2026-05-29 00:00:00', NULL, 'Budapest', 'Budapest', 336000.00, 'rejected', '2026-04-23 17:58:10', '2026-04-23 18:04:12', '2026-04-23 15:58:10', '2026-04-23 16:04:12'),
(14, 13, 3, '2026-04-24 00:00:00', '2026-04-29 00:00:00', NULL, 'Budaörs', 'Budaörs', 175000.00, 'approved', '2026-04-23 18:27:39', '2026-04-23 18:28:35', '2026-04-23 16:27:39', '2026-04-23 16:28:35'),
(15, 14, 5, '2026-04-27 00:00:00', '2026-04-30 00:00:00', NULL, 'Debrecen', 'Debrecen', 33000.00, 'pending_approval', '2026-04-24 14:21:33', NULL, '2026-04-24 12:21:33', '2026-04-24 12:21:33'),
(16, 5, 5, '2026-04-25 00:00:00', '2026-04-26 00:00:00', NULL, 'Debrecen', 'Debrecen', 11000.00, 'rejected', '2026-04-24 14:22:03', '2026-04-24 14:23:10', '2026-04-24 12:22:03', '2026-04-24 12:23:10');

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
(13, 'toth_mark', 'toth@gmail.com', '$2y$12$c.tIRfqyJAtIZaFsS.5KOe.B2wq.obWn.ku5M1/dV./kfZsFeVJ1W', 'Tóth', 'Márk', '2006-07-23', 'AB3124314', 'user', 'active', 0, '2026-04-23 16:26:45', '2026-04-23 16:26:45'),
(14, 'petro_dominik', 'petrodomi@gmail.com', '$2y$12$GcQ8.k3i7M4o4mvN.GDnfeq2tdCb75mmnXnd3m4oH53XJ5R4HYZm.', 'Petró', 'Dominik', '2006-03-23', 'AB1241414', 'user', 'active', 0, '2026-04-24 12:11:48', '2026-04-24 12:11:48');

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
(2, 2, 'Volkswagen', 'Golf', '2020', 'VW-100', 12000.00, NULL, 'petrol', 'manual', 5, 'Budapest', 'Budapest', 0, 1, NULL, '2026-04-24 12:09:19'),
(3, 2, 'Tesla', 'Model 3', '2023', 'ELC-001', 35000.00, NULL, 'electric', 'automatic', 5, 'Budaörs', 'Budaörs', 0, 1, NULL, '2026-04-24 12:09:12'),
(5, 3, 'Ford', 'Focus', '2019', 'FRD-888', 11000.00, NULL, 'petrol', 'manual', 5, 'Debrecen', 'Debrecen', 1, 1, NULL, '2026-04-24 12:23:10'),
(6, 4, 'BMW', 'X5', '2022', 'BMW-999', 45000.00, NULL, 'diesel', 'automatic', 5, 'Szeged', 'Szeged', 1, 1, NULL, '2026-04-23 05:23:56'),
(7, 4, 'Audi', 'A4', '2021', 'AUD-444', 22000.00, NULL, 'petrol', 'automatic', 5, 'Szeged', 'Szeged', 1, 1, NULL, '2026-04-23 07:05:32'),
(8, 4, 'Dacia', 'Duster', '2022', 'DAC-007', 9000.00, NULL, 'petrol', 'manual', 5, 'Szeged', 'Szeged', 1, 0, NULL, '2026-04-24 12:11:06');

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
-- A tábla adatainak kiíratása `vehicle_messages`
--

INSERT INTO `vehicle_messages` (`id`, `vehicle_id`, `sender_id`, `rentalagent_id`, `message`, `is_read`, `created_at`, `updated_at`) VALUES
(2, 3, 13, 2, 'Mikor lesz elérhető újra?', 0, '2026-04-24 12:20:27', '2026-04-24 12:20:27');

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT a táblához `rentalagent_applications`
--
ALTER TABLE `rentalagent_applications`
  MODIFY `application_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `rentals`
--
ALTER TABLE `rentals`
  MODIFY `rental_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
