-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 17-10-2026 a las 16:57:54
-- Versión del servidor: 11.8.9-MariaDB-log
-- Versión de PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `u417714339_Lovemakeupbd`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `id_categoria` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estatus` int(2) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id_categoria`, `nombre`, `estatus`) VALUES
(1, 'Polvo', 1),
(2, 'Base', 1),
(3, 'Sombras', 1),
(4, 'Labiales', 1),
(5, 'Salome', 0),
(6, 'Correctores', 1),
(7, 'Iluminadores', 0),
(8, 'Rubores', 1),
(9, 'Bronceadores', 0),
(10, 'Delineadores de ojos', 0),
(11, 'Pestañas', 1),
(12, 'Pre bases', 0),
(13, 'Fijadores de maquillaje', 0),
(14, 'Brillos labiales', 0),
(15, 'Delineadores de labios', 0),
(16, 'Pomadas para cejas', 0),
(17, 'Geles fijadores de cejas', 0),
(18, 'Pestañas postizas', 0),
(19, 'Paletas de contorno', 0),
(20, 'Correctores de color', 0),
(21, 'Tintas para labios y mejillas', 0),
(22, 'Glitter y pigmentos sueltos', 0),
(23, 'Bálsamos hidratantes', 0),
(24, 'Desmaquillantes trifásicos', 0),
(25, 'Agua micelar', 0),
(26, 'Categoría a', 0),
(27, 'Categoriab', 0),
(28, 'Categoría c', 0),
(29, 'Categoría d', 0),
(30, 'Categoría e', 0),
(31, 'Cejas', 1),
(32, 'Higiene', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compra`
--

CREATE TABLE `compra` (
  `id_compra` int(11) NOT NULL,
  `fecha_entrada` datetime DEFAULT NULL,
  `id_proveedor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `compra`
--

INSERT INTO `compra` (`id_compra`, `fecha_entrada`, `id_proveedor`) VALUES
(1, '2026-04-21 12:44:58', 1),
(2, '2026-04-21 19:00:46', 1),
(3, '2026-04-22 13:27:27', 2),
(4, '2026-04-22 13:28:17', 2),
(5, '2026-04-22 13:29:10', 3),
(6, '2026-06-03 13:29:53', 3),
(7, '2026-04-22 13:33:47', 4),
(8, '2026-04-22 13:34:48', 4),
(9, '2026-04-22 13:35:19', 2),
(10, '2026-07-06 11:02:35', 1),
(11, '2026-08-19 18:28:43', 2),
(12, '2026-08-19 18:29:11', 4),
(13, '2026-08-19 18:31:20', 2),
(14, '2026-08-20 16:25:20', 1),
(15, '2026-08-24 13:10:07', 4),
(16, '2026-08-26 23:34:59', 1),
(17, '2026-08-27 22:54:51', 2),
(18, '2026-08-27 23:17:50', 3),
(19, '2026-08-27 23:18:32', 4),
(20, '2026-08-29 23:41:11', 2),
(21, '2026-08-29 23:48:38', 4),
(22, '2026-08-29 23:49:32', 1),
(23, '2026-08-29 23:50:28', 2),
(24, '2026-08-30 22:53:02', 2),
(25, '2026-09-01 21:33:51', 3),
(26, '2026-09-01 21:34:21', 1),
(27, '2026-09-01 21:55:44', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compra_detalles`
--

CREATE TABLE `compra_detalles` (
  `id_detalle_compra` int(11) NOT NULL,
  `id_compra` int(11) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio_total` decimal(12,2) DEFAULT NULL,
  `precio_unitario` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `compra_detalles`
--

INSERT INTO `compra_detalles` (`id_detalle_compra`, `id_compra`, `id_producto`, `cantidad`, `precio_total`, `precio_unitario`) VALUES
(1, 1, 5, 100, 10.00, 0.10),
(2, 2, 8, 20, 16.00, 0.80),
(3, 2, 6, 30, 21.00, 0.70),
(4, 2, 7, 24, 12.00, 0.50),
(5, 3, 12, 50, 250.00, 5.00),
(6, 4, 9, 100, 250.00, 2.50),
(7, 5, 7, 50, 125.00, 2.50),
(9, 7, 11, 160, 320.00, 2.00),
(10, 8, 10, 140, 490.00, 3.50),
(11, 9, 14, 100, 220.00, 2.20),
(12, 6, 13, 198, 297.00, 1.50),
(13, 10, 16, 50, 50.00, 1.00),
(14, 10, 17, 50, 60.00, 1.20),
(15, 10, 18, 50, 60.00, 1.20),
(16, 11, 22, 20, 160.00, 8.00),
(17, 11, 21, 20, 20.00, 1.00),
(18, 11, 20, 12, 426.00, 35.50),
(19, 12, 19, 20, 20.00, 1.00),
(20, 13, 23, 25, 87.50, 3.50),
(21, 14, 26, 20, 30.00, 1.50),
(22, 14, 24, 23, 57.50, 2.50),
(23, 14, 25, 30, 30.00, 1.00),
(24, 15, 27, 15, 15.00, 1.00),
(25, 15, 28, 30, 33.00, 1.10),
(26, 15, 29, 30, 36.00, 1.20),
(27, 15, 30, 15, 22.50, 1.50),
(28, 16, 31, 24, 58.80, 2.45),
(29, 17, 8, 20, 20.00, 1.00),
(30, 17, 18, 10, 12.00, 1.20),
(31, 18, 37, 20, 140.00, 7.00),
(32, 18, 36, 20, 60.00, 3.00),
(33, 18, 35, 20, 30.00, 1.50),
(34, 18, 34, 24, 48.00, 2.00),
(35, 19, 32, 48, 120.00, 2.50),
(36, 19, 33, 24, 60.00, 2.50),
(37, 20, 38, 24, 39.60, 1.65),
(38, 20, 41, 24, 39.12, 1.63),
(39, 21, 44, 24, 63.36, 2.64),
(40, 21, 45, 24, 60.24, 2.51),
(41, 22, 42, 24, 36.96, 1.54),
(42, 22, 43, 24, 27.60, 1.15),
(43, 23, 39, 48, 53.28, 1.11),
(44, 23, 40, 48, 55.20, 1.15),
(45, 24, 47, 24, 39.60, 1.65),
(46, 24, 46, 24, 51.60, 2.15),
(47, 24, 48, 24, 61.20, 2.55),
(48, 24, 49, 24, 74.64, 3.11),
(49, 24, 27, 24, 15.60, 0.65),
(50, 25, 57, 24, 24.00, 1.00),
(51, 25, 56, 24, 26.40, 1.10),
(52, 25, 55, 36, 63.00, 1.75),
(53, 25, 54, 36, 41.40, 1.15),
(54, 25, 53, 36, 46.80, 1.30),
(55, 25, 51, 24, 37.20, 1.55),
(56, 25, 50, 24, 42.96, 1.79),
(57, 26, 52, 24, 22.80, 0.95),
(58, 27, 58, 36, 30.24, 0.84),
(59, 27, 59, 24, 20.88, 0.87),
(60, 27, 60, 24, 20.40, 0.85),
(61, 27, 61, 24, 19.20, 0.80);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comprobante_pago`
--

CREATE TABLE `comprobante_pago` (
  `id_comprobante` int(11) NOT NULL,
  `id_pago` int(11) DEFAULT NULL,
  `imagen` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `comprobante_pago`
--

INSERT INTO `comprobante_pago` (`id_comprobante`, `id_pago`, `imagen`) VALUES
(1, 1, 'assets/img/captures/img_69e7a9cdcfc38.png'),
(2, 7, 'assets/img/captures/img_69e93341ae01c.jpeg'),
(3, 8, 'assets/img/captures/img_69e9335e7b9b7.jpeg'),
(4, 9, 'assets/img/captures/img_69e933dfa05fd.jpeg'),
(5, 10, 'assets/img/captures/img_69e9342b52332.jpeg'),
(6, 11, 'assets/img/captures/img_69e934b03d78f.jpeg'),
(7, 12, 'assets/img/captures/img_69e942327642f.jpeg'),
(8, 13, 'assets/img/captures/img_69e97ec85244b.jpeg'),
(9, 14, 'assets/img/captures/img_6a163a18012e5.jpeg'),
(10, 18, 'assets/img/captures/img_6a4c00e9b2539.jpeg'),
(11, 20, 'assets/img/captures/img_6a4c03713d277.jpeg'),
(12, 60, 'assets/img/captures/img_6a7f883bdd481.jpeg'),
(13, 63, 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAL/AvoDASI'),
(14, 64, 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAL/AvoDASI'),
(15, 65, 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAL/AvoDASI'),
(16, 66, 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAL/AvoDASI'),
(17, 67, 'assets/img/captures/img_6a7fa7aa85fbc.jpg'),
(18, 68, 'assets/img/captures/img_6a808e9c02774.jpeg'),
(19, 69, 'assets/img/captures/img_6a80f4642b2f8.jpg'),
(20, 70, 'assets/img/captures/img_6a80f80126912.jpg'),
(21, 71, 'assets/img/captures/img_6a80f9ec72d29.jpg'),
(22, 76, 'assets/img/captures/img_6a8f9ce50ce03.jpeg'),
(23, 77, 'assets/img/captures/img_6a8f9e1f61ba7.jpeg'),
(24, 78, 'assets/img/captures/img_6a8f9ee571a1a.jpeg'),
(25, 79, 'assets/img/captures/img_6a8f9f1bebef6.jpeg'),
(26, 80, 'assets/img/captures/img_6a8faa8a050f4.jpeg'),
(27, 81, 'assets/img/captures/img_6a90d9a991afe.jpg'),
(28, 82, 'assets/img/captures/img_6a90d9f630dd6.jpg'),
(29, 83, 'assets/img/captures/img_6a90e60c27b24.jpeg'),
(30, 84, 'assets/img/captures/img_6a90e6b7909a8.jpeg'),
(31, 85, 'assets/img/captures/img_6a90e815457b0.jpeg'),
(32, 86, 'assets/img/captures/img_6a90e9b719586.jpeg'),
(33, 87, 'assets/img/captures/img_6a90eb7e6770a.jpeg'),
(34, 88, 'assets/img/captures/img_6a90ec8f6267a.jpeg'),
(35, 89, 'assets/img/captures/img_6a90ed6b8cac6.jpeg'),
(36, 90, 'assets/img/captures/img_6a90ee1ee4823.jpeg'),
(37, 91, 'assets/img/captures/img_6a90eed371314.jpeg'),
(38, 92, 'assets/img/captures/img_6a90ef9bc4a6d.jpeg'),
(39, 93, 'assets/img/captures/img_6a90f17f60724.jpeg'),
(40, 94, 'assets/img/captures/img_6a90f22568cfb.jpeg'),
(41, 95, 'assets/img/captures/img_6a90f31a87aa6.jpeg'),
(42, 96, 'assets/img/captures/img_6a90f4ae6d6a1.jpeg'),
(43, 97, 'assets/img/captures/img_6a90f79d63580.jpeg'),
(44, 98, 'assets/img/captures/img_6a90ff12711aa.jpeg'),
(45, 105, 'assets/img/captures/img_6a910996a71f9.jpeg'),
(46, 119, 'assets/img/captures/img_6a9586a0f3bce.png'),
(47, 120, 'assets/img/captures/img_6a9596f5c4954.jpg'),
(48, 121, 'assets/img/captures/img_6a959e6a9e843.jpg'),
(49, 122, 'assets/img/captures/img_6a9612c0cd5c6.jpg'),
(50, 123, 'assets/img/captures/img_6a9705ca52985.png'),
(51, 124, 'assets/img/captures/img_6a9708c4f3115.jpg'),
(52, 125, 'assets/img/captures/img_6a9789103e3f4.jpeg'),
(53, 126, 'assets/img/captures/img_6a9789e4b4d56.jpeg'),
(54, 127, 'assets/img/captures/img_6a9795f86088b.jpg'),
(55, 128, 'assets/img/captures/img_6a9797a0097bd.jpg'),
(56, 129, 'assets/img/captures/img_6a98d021882c8.png'),
(57, 130, 'https://res.cloudinary.com/xtyekdoi/image/upload/v1788400917/lovemakeup/comprobantes/nezopiqte8ci7meft082.png'),
(58, 131, 'https://res.cloudinary.com/xtyekdoi/image/upload/v1788401167/lovemakeup/comprobantes/wbwnrrz0mhqpvygr8zbp.png'),
(59, 132, 'https://res.cloudinary.com/xtyekdoi/image/upload/v1788401498/lovemakeup/comprobantes/xsqzl1vmagtstp4bzt4w.png'),
(60, 133, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788402323/lovemakeup/comprobantes/upt35f7zdftplyk7acm0.png'),
(61, 134, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788474905/lovemakeup/comprobantes/g5bnijjzbieilcm7qd5r.jpg'),
(62, 135, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788482432/lovemakeup/comprobantes/hilrpxod6yvg4xgvkwtc.png'),
(63, 136, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788541320/lovemakeup/comprobantes/bfaw2jj7tiy1gplghezw.jpg'),
(64, 137, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1790963894/lovemakeup/comprobantes/qafzdywwvnglk8dzs1v1.jpg'),
(65, 138, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791318121/lovemakeup/comprobantes/g3cfibqmiiylftzgri3d.jpg'),
(66, 139, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791427745/lovemakeup/comprobantes/g9pinn86obzwaxcf9kff.jpg'),
(67, 140, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791569696/lovemakeup/comprobantes/y0kndirpre4lsnx6wg0e.jpg'),
(68, 141, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791576532/lovemakeup/comprobantes/afqsybfrqj1zbdetu6sw.jpg'),
(69, 142, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791643661/lovemakeup/comprobantes/bb3xqsxnwablfugsvtwd.jpg'),
(70, 143, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791669773/lovemakeup/comprobantes/rg9nvaekg0db4m6omsia.png'),
(71, 144, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791735169/lovemakeup/comprobantes/sikt9r3bsaafabtmdqnz.jpg'),
(72, 145, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791744183/lovemakeup/comprobantes/vai8i04kp2ajxggwxjvg.png'),
(73, 146, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791754998/lovemakeup/comprobantes/vutkv35cepezio4kcjjs.jpg'),
(74, 147, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791755008/lovemakeup/comprobantes/cjkedxwdkwhm4w2snrxn.jpg'),
(75, 148, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791755328/lovemakeup/comprobantes/s30e9n44alfhgkkc4a3b.jpg'),
(76, 149, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791778255/lovemakeup/comprobantes/znzv4v0mtw8tlcdkx5ly.jpg'),
(77, 150, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791789761/lovemakeup/comprobantes/schjkll57pv0pr8g1fu8.jpg'),
(78, 151, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791792193/lovemakeup/comprobantes/o1otdwnuca2jygek3iz8.jpg'),
(79, 152, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791843904/lovemakeup/comprobantes/bnmpbxs8j8e3kdctvkht.jpg'),
(80, 153, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791844154/lovemakeup/comprobantes/zaquaaf5ciemxzfybdh0.jpg'),
(81, 154, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791844786/lovemakeup/comprobantes/h7ludo8x1uxbruzbkvop.jpg'),
(82, 155, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791847083/lovemakeup/comprobantes/hv150nj8eta51wokcylk.jpg'),
(83, 156, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791847805/lovemakeup/comprobantes/rtrtkumvp0ag7lrzfcra.jpg'),
(84, 157, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791848382/lovemakeup/comprobantes/kzaxdpdbmqmb6sxrq4pd.jpg'),
(85, 158, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791849766/lovemakeup/comprobantes/kwn92k4eprxfvkmvj3dq.jpg'),
(86, 159, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791850236/lovemakeup/comprobantes/mdl8uaf044oi0bw99dq0.jpg'),
(87, 160, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791850668/lovemakeup/comprobantes/ffum9u6hkgrddgnkvffo.jpg'),
(88, 161, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791851146/lovemakeup/comprobantes/fhbsdcqbxt9szviu4q54.jpg'),
(89, 162, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791851567/lovemakeup/comprobantes/lplpr0sfvzszbyae0is9.jpg'),
(90, 163, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791851863/lovemakeup/comprobantes/v8knqww2ruacb2snqhmz.jpg'),
(91, 164, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1791939332/lovemakeup/comprobantes/qpyndpp3wxyddaztpihu.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `delivery`
--

CREATE TABLE `delivery` (
  `id_delivery` int(11) NOT NULL,
  `nombre` varchar(80) DEFAULT NULL,
  `tipo` varchar(80) DEFAULT NULL,
  `contacto` varchar(100) DEFAULT NULL,
  `estatus` int(2) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `delivery`
--

INSERT INTO `delivery` (`id_delivery`, `nombre`, `tipo`, `contacto`, `estatus`) VALUES
(1, 'Erick torrealba', 'Bicicleta', '0424-5196914', 1),
(2, 'Miguel torres', 'Moto', '0452-6875585', 1),
(3, 'Daniel zanchez', 'Bicicleta', '0424-8596588', 1),
(4, 'Rhichard virguez', 'Carro', '0424-5633699', 1),
(5, 'Angel sanchez', 'Moto', '0422-5588855', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pago`
--

CREATE TABLE `detalle_pago` (
  `id_pago` int(11) NOT NULL,
  `monto` decimal(12,2) DEFAULT NULL,
  `monto_usd` decimal(12,2) DEFAULT NULL,
  `id_metodopago` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `detalle_pago`
--

INSERT INTO `detalle_pago` (`id_pago`, `monto`, `monto_usd`, `id_metodopago`) VALUES
(1, 5780.40, 12.00, 1),
(2, 14450.97, 3.00, 3),
(3, 19310.34, 40.00, 4),
(4, 199379.30, 41.30, 4),
(5, 31862.07, 66.00, 1),
(6, 8689.65, 18.00, 3),
(7, 3475.87, 7.20, 1),
(8, 1448.28, 3.00, 1),
(9, 2268.97, 4.70, 1),
(10, 8206.92, 17.00, 1),
(11, 1931.04, 4.00, 1),
(12, 4200.01, 8.70, 1),
(13, 3379.32, 7.00, 1),
(14, 2516.33, 4.70, 1),
(15, 2253.16, 4.00, 3),
(16, 7337.55, 11.00, 3),
(17, 2001.15, 0.30, 4),
(18, 2001.15, 3.00, 1),
(19, 0.00, 50.00, 5),
(20, 2668.20, 4.00, 1),
(21, NULL, NULL, NULL),
(22, NULL, NULL, NULL),
(23, NULL, NULL, NULL),
(24, NULL, NULL, NULL),
(25, NULL, NULL, NULL),
(26, NULL, NULL, NULL),
(27, NULL, NULL, NULL),
(28, NULL, NULL, NULL),
(29, NULL, NULL, NULL),
(30, NULL, NULL, NULL),
(31, NULL, NULL, NULL),
(32, NULL, NULL, NULL),
(33, NULL, NULL, NULL),
(34, NULL, NULL, NULL),
(35, NULL, NULL, NULL),
(36, NULL, NULL, NULL),
(37, NULL, NULL, NULL),
(38, NULL, NULL, NULL),
(39, NULL, NULL, NULL),
(40, NULL, NULL, NULL),
(41, NULL, NULL, NULL),
(42, NULL, NULL, NULL),
(43, NULL, NULL, NULL),
(44, NULL, NULL, NULL),
(45, NULL, NULL, NULL),
(46, NULL, NULL, NULL),
(47, NULL, NULL, NULL),
(48, NULL, NULL, NULL),
(49, 117.50, 2.50, 1),
(50, 50131.78, 6.80, 3),
(51, 0.00, 40.00, 5),
(52, 2211.70, 3.00, 3),
(53, 5897.86, 8.00, 3),
(54, 75934.91, 10.30, 3),
(55, 9960.01, 13.50, 3),
(56, 10000.00, 4.00, 1),
(57, 5000.00, 5.50, 1),
(58, 3067.44, 4.00, 1),
(59, 4240.89, 5.50, 1),
(60, 6399.88, 8.30, 1),
(61, 5937.24, 7.70, 1),
(62, 5011.95, 6.50, 1),
(63, 7325.17, 9.50, 1),
(64, 3084.28, 4.00, 1),
(65, 3084.28, 4.00, 1),
(66, 3084.28, 4.00, 1),
(67, 3084.28, 4.00, 1),
(68, 3624.03, 4.70, 1),
(69, 2698.75, 3.50, 1),
(70, 4240.89, 5.50, 1),
(71, 4240.89, 5.50, 1),
(72, 0.00, 42.00, 5),
(73, 54419.13, 7.00, 3),
(74, 4664.50, 6.00, 1),
(75, 4275.79, 5.50, 3),
(76, 6615.17, 8.40, 1),
(77, 2913.82, 3.70, 1),
(78, 4331.36, 5.50, 1),
(79, 2913.82, 3.70, 1),
(80, 2913.82, 3.70, 1),
(81, 5618.37, 7.10, 1),
(82, 2373.96, 3.00, 1),
(83, 47479.20, 60.00, 1),
(84, 2373.96, 3.00, 1),
(85, 3719.20, 4.70, 1),
(86, 5143.58, 6.50, 1),
(87, 6726.22, 8.50, 1),
(88, 9495.84, 12.00, 1),
(89, 3560.94, 4.50, 1),
(90, 4352.26, 5.50, 1),
(91, 7913.20, 10.00, 1),
(92, 9495.84, 12.00, 1),
(93, 18596.02, 23.50, 1),
(94, 5934.90, 7.50, 1),
(95, 5143.58, 6.50, 1),
(96, 8467.12, 10.70, 1),
(97, 6726.22, 8.50, 1),
(98, 2373.96, 3.00, 1),
(99, 4747.95, 6.00, 3),
(100, 7517.59, 9.50, 3),
(101, 3719.23, 4.70, 3),
(102, 2769.64, 3.50, 3),
(103, 0.00, 10.00, 5),
(104, 0.00, 10.00, 5),
(105, 8708.37, 11.00, 1),
(106, 3166.67, 4.00, 3),
(107, 7125.00, 9.00, 3),
(108, 1187.50, 1.50, 1),
(109, 0.00, 10.00, 5),
(110, 7520.83, 9.50, 3),
(111, 14250.00, 18.00, 3),
(112, 0.00, 7.00, 5),
(113, 395.83, 0.50, 4),
(114, 0.00, 2.00, 5),
(115, 395.83, 0.50, 4),
(116, 3166.67, 4.00, 1),
(117, 0.00, 15.00, 5),
(118, 7441.67, 9.40, 3),
(119, 7154.91, 9.00, 1),
(120, 2384.97, 3.00, 1),
(121, 2782.47, 3.50, 1),
(122, 2782.47, 3.50, 1),
(123, 13571.61, 17.00, 1),
(124, 3752.15, 4.70, 1),
(125, 5588.31, 7.00, 1),
(126, 16365.77, 20.50, 1),
(127, 7983.30, 10.00, 1),
(128, 27143.22, 34.00, 1),
(129, 3765.55, 4.70, 1),
(130, 3765.55, 4.70, 1),
(131, 4406.49, 5.50, 1),
(132, 2403.54, 3.00, 1),
(133, 4406.49, 5.50, 1),
(134, 1609.62, 2.00, 1),
(135, 2414.43, 3.00, 1),
(136, 2422.17, 3.00, 1),
(137, 10138.75, 11.70, 1),
(138, 7153.60, 8.20, 1),
(139, 55490.75, 63.50, 1),
(140, 3064.78, 3.50, 1),
(141, 3064.78, 3.50, 1),
(142, 3064.78, 3.50, 1),
(143, 8231.11, 9.40, 1),
(144, 4115.56, 4.70, 1),
(145, 6129.55, 7.00, 1),
(146, 4115.56, 4.70, 1),
(147, 3064.78, 3.50, 1),
(148, 3064.78, 3.50, 1),
(149, 3064.78, 3.50, 1),
(150, 3064.78, 3.50, 1),
(151, 3064.78, 3.50, 1),
(152, 3064.78, 3.50, 1),
(153, 2977.21, 3.40, 1),
(154, 3064.78, 3.50, 1),
(155, 13134.75, 15.00, 1),
(156, 17513.00, 20.00, 1),
(157, 5253.90, 6.00, 1),
(158, 4553.38, 5.20, 1),
(159, 21978.82, 25.10, 1),
(160, 8756.50, 10.00, 1),
(161, 24518.20, 28.00, 1),
(162, 8231.11, 9.40, 1),
(163, 26269.50, 30.00, 1),
(164, 6137.60, 7.00, 1),
(165, 0.00, 5.00, 5),
(166, 4395.61, 5.00, 1),
(167, 0.00, 5.00, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direccion`
--

CREATE TABLE `direccion` (
  `id_direccion` int(11) NOT NULL,
  `cedula` varchar(15) DEFAULT NULL,
  `direccion_envio` text DEFAULT NULL,
  `sucursal_envio` varchar(100) DEFAULT NULL,
  `fecha_entrega` date DEFAULT NULL,
  `id_metodoentrega` int(11) DEFAULT NULL,
  `id_delivery` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `direccion`
--

INSERT INTO `direccion` (`id_direccion`, `cedula`, `direccion_envio`, `sucursal_envio`, `fecha_entrega`, `id_metodoentrega`, `id_delivery`) VALUES
(1, '30716541', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(2, '30716541', 'Zona: norte, Parroquia: Tamaca, Sector: Tamaca Centro, Dirección: urb don aurelio calle 13 casa 15', '', NULL, 1, 1),
(3, '11697944', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(4, '11547769', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(5, '30803034', 'Zona: norte, Parroquia: Tamaca, Sector: Tamaca Centro, Dirección: sector andres bello calle 12 casa B2', '', NULL, 1, 2),
(6, '31765947', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(7, '30559878', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(8, '25293863', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(9, '25293863', 'Almarriera', '200488', NULL, 3, NULL),
(10, NULL, NULL, NULL, NULL, NULL, NULL),
(11, NULL, NULL, NULL, NULL, NULL, NULL),
(12, NULL, NULL, NULL, NULL, NULL, NULL),
(13, NULL, NULL, NULL, NULL, NULL, NULL),
(14, NULL, NULL, NULL, NULL, NULL, NULL),
(15, NULL, NULL, NULL, NULL, NULL, NULL),
(16, NULL, NULL, NULL, NULL, NULL, NULL),
(17, NULL, NULL, NULL, NULL, NULL, NULL),
(18, NULL, NULL, NULL, NULL, NULL, NULL),
(19, NULL, NULL, NULL, NULL, NULL, NULL),
(20, NULL, NULL, NULL, NULL, NULL, NULL),
(21, NULL, NULL, NULL, NULL, NULL, NULL),
(22, NULL, NULL, NULL, NULL, NULL, NULL),
(23, NULL, NULL, NULL, NULL, NULL, NULL),
(24, NULL, NULL, NULL, NULL, NULL, NULL),
(25, NULL, NULL, NULL, NULL, NULL, NULL),
(26, NULL, NULL, NULL, NULL, NULL, NULL),
(27, NULL, NULL, NULL, NULL, NULL, NULL),
(28, NULL, NULL, NULL, NULL, NULL, NULL),
(29, NULL, NULL, NULL, NULL, NULL, NULL),
(30, NULL, NULL, NULL, NULL, NULL, NULL),
(31, NULL, NULL, NULL, NULL, NULL, NULL),
(32, NULL, NULL, NULL, NULL, NULL, NULL),
(33, NULL, NULL, NULL, NULL, NULL, NULL),
(34, NULL, NULL, NULL, NULL, NULL, NULL),
(35, NULL, NULL, NULL, NULL, NULL, NULL),
(36, NULL, NULL, NULL, NULL, NULL, NULL),
(37, NULL, NULL, NULL, NULL, NULL, NULL),
(38, NULL, 'Retiro en Tienda Fisica', NULL, NULL, 2, NULL),
(39, '10200300', '', '', NULL, 4, NULL),
(40, '10200300', 'Cabudare-centro', 'SUC-1045', NULL, 3, NULL),
(41, '10200300', 'Cabudare-centro', 'SUC-145', NULL, 2, NULL),
(42, '31271852', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(43, '30665005', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(44, '30665005', 'Valle lindo', '1306000', NULL, 2, NULL),
(45, '29997994', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(46, '10200300', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(47, '10200300', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(48, '10200300', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(49, '10200300', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(50, '10200300', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(51, '30559878', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(52, '30716541', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(53, '30716541', '         ', '            ', NULL, 2, NULL),
(54, '12241103', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(55, '31765947', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(56, '31765947', 'sector andres bello calle 12 casa B2 calle 1 calle', '545646', NULL, 2, NULL),
(57, '31765947', 'Zona: sur, Parroquia: Juan de Villegas, Sector: La Paz, Dirección: sector andres bello calle 12 casa B2', '', NULL, 1, 2),
(58, '31765947', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(59, '16210068', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(60, '16210068', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(61, '16210068', 'valle lindo', '130600', NULL, 2, NULL),
(62, '29762707', 'Zona: este, Parroquia: Cabudare, Sector: La Mora, Dirección: valle lindo', '', NULL, 1, 2),
(63, '21459699', 'CARRERA 25 CON CALLE 41 EDIF COSTA ESMERALDA LOCAL', '665555', NULL, 3, NULL),
(64, '21129740', 'Zona: norte, Parroquia: Tamaca, Sector: Tamaca Centro, Dirección: sector andres bello calle 12 casa B2 calle 1 calle', '', NULL, 1, 2),
(65, '30673077', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(66, '30318119', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(67, '11269334', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(68, '21141772', 'Zona: este, Parroquia: Cabudare, Sector: La Mata, Dirección: sector andres bello calle 12 casa B2 calle 1 calle', '', NULL, 1, 4),
(69, '20186429', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(70, '29945119', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(71, '30803034', 'valle lindo', '130600', NULL, 2, NULL),
(72, '30266662', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(73, '11697944', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(74, '30559878', 'Sucursal barquisimeto', '55656', NULL, 2, NULL),
(75, '10200300', 'Zona: este, Parroquia: Santa Rosa, Sector: El Cercado, Dirección: Callejón santa fe', '', NULL, 1, 1),
(76, '10200300', 'San josede villegas', '55555', NULL, 2, NULL),
(77, '10200300', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(78, '31765947', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(79, '31765947', 'Holaaaaaaa', '6797979', NULL, 3, NULL),
(80, '30301154', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(81, '30301154', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(82, '29945088', 'Guacara calle piar cruce con jacinto Lara cc San Pedro', '0802000', NULL, 2, NULL),
(83, '29945088', 'Guacara calle piar', '082000', NULL, 2, NULL),
(84, '30559878', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(85, '30559878', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL),
(86, '10200300', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(87, '30716541', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(88, '10200300', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(89, '31271852', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(90, '10200300', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(91, '30716541', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(92, '15691374', 'Cc Babilon', '112222', NULL, 3, NULL),
(93, '30716541', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(94, '14335762', 'Zona: sur, Parroquia: Union, Sector: San Jacinto, Dirección: No me acuerdo', '', NULL, 1, 1),
(95, '31271852', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(96, '10200300', 'Zona: centro, Parroquia: Catedral, Sector: Colinas del Viento, Dirección: cabudare barquisimeto', '', NULL, 1, 3),
(97, '32063438', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(98, '10200300', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(99, '30716541', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(100, '27349943', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(101, '30716541', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(102, '10200300', 'Zona: este, Parroquia: Cabudare, Sector: El Recreo, Dirección: Cabudareeeeee', '', NULL, 1, 1),
(103, '30753995', 'Zona: oeste, Parroquia: Concepcion, Sector: Barrio Bolivar, Dirección: Síiiiiiiiiiiiiii', '', NULL, 1, 2),
(104, '30753995', 'Zona: centro, Parroquia: Catedral, Sector: Colinas del Viento, Dirección: Hshdhshshshshshhs', '', NULL, 1, 5),
(105, '30716541', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(106, '30716541', 'Valle lindo', '21312', NULL, 2, NULL),
(107, '30716541', 'Zona: norte, Parroquia: Tamaca, Sector: Tamaca Centro, Dirección: Urb don aurelio', '', NULL, 1, 4),
(108, '30716541', 'Zona: norte, Parroquia: Tamaca, Sector: Tamaca Centro, Dirección: Urb don Aurelio calle 13 casa 15', '', NULL, 1, 4),
(109, '30716541', 'Zona: norte, Parroquia: Tamaca, Sector: Tamaca Centro, Dirección: Urb don Aurelio calle 13 casa 15', '', NULL, 1, 4),
(110, '11697944', 'Zona: norte, Parroquia: Tamaca, Sector: Tamaca Centro, Dirección: Urb don Aurelio calle 13 casa 15', '', NULL, 1, 2),
(111, '30301154', 'Zona: norte, Parroquia: Tamaca, Sector: Tamaca Centro, Dirección: Urb don Aurelio calle 13 casa 15', '', NULL, 1, 5),
(112, '30301154', 'Valle lindo', '114000', NULL, 2, NULL),
(113, '30601595', 'Valle lindo', '114000', NULL, 2, NULL),
(114, '30601595', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(115, '30673077', 'Valle lindo', '114000', NULL, 2, NULL),
(116, '30673077', 'Retiro en Tienda Fisica', '', NULL, 4, NULL),
(117, '30559878', 'Retiro en Tienda Física (Barquisimeto)', '', NULL, 4, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lista_deseo`
--

CREATE TABLE `lista_deseo` (
  `id_lista` int(11) NOT NULL,
  `cedula` varchar(15) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `lista_deseo`
--

INSERT INTO `lista_deseo` (`id_lista`, `cedula`, `id_producto`) VALUES
(1, '30803034', 6),
(2, '30803034', 11),
(36, '28653562', 6),
(41, '30665005', 6),
(45, '16210068', 21),
(47, '29762707', 8),
(48, '33466179', 7),
(49, '33466179', 31),
(50, '21129740', 20),
(51, '30673077', 5),
(52, '30318119', 5),
(53, '30318119', 14),
(54, '30318119', 17),
(55, '30318119', 18),
(56, '30318119', 20),
(57, '30318119', 21),
(58, '30318119', 19),
(59, '30318119', 23),
(60, '30318119', 24),
(61, '30318119', 25),
(62, '30318119', 22),
(63, '30601595', 31),
(64, '30601595', 22),
(65, '11269334', 10),
(66, '31843719', 17),
(68, '31843719', 13),
(70, '21141772', 16),
(71, '21141772', 12),
(72, '20186429', 11),
(73, '30759451', 22),
(74, '29945119', 5),
(75, '29945119', 6),
(76, '29945119', 8),
(77, '29945119', 7),
(78, '29506932', 5),
(79, '30301154', 58),
(85, '29945088', 23),
(86, '29945088', 22),
(90, '31765947', 8),
(91, '31271852', 7),
(93, '31271852', 10),
(115, '15691374', 7),
(117, '15691374', 11),
(119, '15691374', 26),
(120, '15691374', 12),
(121, '15691374', 36),
(128, '30716541', 5),
(129, '30716541', 6),
(133, '30716541', 9),
(135, '31271852', 9),
(144, '11697944', 6),
(145, '30301154', 5),
(146, '30301154', 11),
(147, '30301154', 20),
(148, '30601595', 20),
(150, '30673077', 11);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marca`
--

CREATE TABLE `marca` (
  `id_marca` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estatus` int(2) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `marca`
--

INSERT INTO `marca` (`id_marca`, `nombre`, `estatus`) VALUES
(1, 'Sin Marca', 0),
(2, 'Ushas', 1),
(3, 'Salome', 1),
(4, 'Valmy', 0),
(5, 'Mon Reve', 0),
(6, 'Dolce Bella', 1),
(7, 'Ame', 0),
(8, 'Maybelline', 0),
(9, 'Clinique', 0),
(10, 'Kleancolor', 0),
(11, 'Revlon', 0),
(12, 'Prosa', 1),
(13, 'Essence', 0),
(14, 'Catrice', 0),
(15, 'Aria Comestics', 1),
(16, 'Farmasi', 0),
(17, 'Rude', 0),
(18, 'Milani', 0),
(19, 'AOA Studio', 0),
(20, 'Eylure', 0),
(21, 'Elf', 0),
(22, 'Wet n Wild', 0),
(23, 'Kiss Beauty', 1),
(24, 'Aaa', 0),
(25, 'Bbb', 0),
(26, 'Ccc', 0),
(27, 'famo beauty', 1),
(28, 'sadoer', 1),
(29, 'Karite', 1),
(30, 'Trenty', 1),
(31, 'ken y coco', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodo_entrega`
--

CREATE TABLE `metodo_entrega` (
  `id_entrega` int(11) NOT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `estatus` int(2) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `metodo_entrega`
--

INSERT INTO `metodo_entrega` (`id_entrega`, `nombre`, `descripcion`, `estatus`) VALUES
(1, 'Delivery', 'Barquisimeto', 1),
(2, 'MRW', 'Envió nacionales', 1),
(3, 'ZOOM', 'Envio nacionales', 1),
(4, 'Retiro en Tienda Fisica', 'Tienda Fisica', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodo_pago`
--

CREATE TABLE `metodo_pago` (
  `id_metodopago` int(11) NOT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `requiere_banco` int(2) DEFAULT NULL,
  `estatus` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `metodo_pago`
--

INSERT INTO `metodo_pago` (`id_metodopago`, `nombre`, `descripcion`, `requiere_banco`, `estatus`) VALUES
(1, 'Pago Movil', 'Pagos en moneda nacional Bs', 1, 1),
(2, 'Transferencia Bancaria', 'Pagos en moneda nacional Bs', 1, 1),
(3, 'Punto de Venta', 'Pagos en moneda nacional Bs Atravez con tarjeta Bancaria', 0, 1),
(4, 'Efectivo Bs', 'Pagos en moneda nacional Bs', 0, 1),
(5, 'Divisas (Dolares $)', 'Pagos en moneda extranjera Dolares $', 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id_notificacion` int(11) NOT NULL,
  `titulo` varchar(100) DEFAULT NULL,
  `mensaje` varchar(100) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL,
  `id_pedido` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `notificaciones`
--

INSERT INTO `notificaciones` (`id_notificacion`, `titulo`, `mensaje`, `fecha`, `estado`, `id_pedido`) VALUES
(1, 'Nuevo pedido web', 'Pedido #1 por Bs. 5780.40', '2026-04-21 12:46:00', '2', 1),
(2, 'Nuevo pedido web', 'Pedido #7 por Bs. 3475.87', '2026-04-22 04:44:00', '2', 7),
(3, 'Nueva reserva', 'Reserva #8 registrada el 2026-04-22 16:45:18', '2026-04-22 16:45:18', '2', 8),
(4, 'Nuevo pedido web', 'Pedido #9 por Bs. 2268.97', '2026-04-22 04:47:00', '1', 9),
(5, 'Nuevo pedido web', 'Pedido #10 por Bs. 8206.92', '2026-04-22 04:48:00', '2', 10),
(6, 'Nueva reserva', 'Reserva #11 registrada el 2026-04-22 16:50:56', '2026-04-22 16:50:56', '2', 11),
(7, 'Nuevo pedido web', 'Pedido #12 por Bs. 4200.01', '2026-04-22 05:48:00', '2', 12),
(8, 'Nuevo pedido web', 'Pedido #13 por Bs. 3379.32', '2026-04-22 10:07:00', '2', 13),
(9, 'Nuevo pedido web', 'Pedido #14 por Bs. 2516.33', '2026-05-26 08:26:00', '2', 14),
(10, 'Nuevo pedido web', 'Pedido #17 por Bs. 2001.15', '2026-07-06 03:24:00', '1', 17),
(11, 'Nuevo pedido web', 'Pedido #19 por Bs. 2668.20', '2026-07-06 03:35:00', '2', 19),
(13, 'Nuevo pedido web', 'Pedido #55 por Bs. 10000.00', '2026-08-13 08:47:00', '1', 55),
(14, 'Nuevo pedido web', 'Pedido #56 por Bs. 5000.00', '2026-08-13 08:52:00', '1', 56),
(15, 'Nuevo pedido web', 'Pedido #57 por Bs. 3067.44', '2026-08-13 09:07:00', '2', 57),
(16, 'Nuevo pedido web', 'Pedido #58 por Bs. 4240.89', '2026-08-14 04:44:00', '1', 58),
(18, 'Nuevo pedido web', 'Pedido #59 por Bs. 6399.88', '2026-08-14 05:27:00', '1', 59),
(21, 'Nuevo pedido web', 'Pedido #60 por Bs. 5937.24', '2026-08-14 05:33:00', '1', 60),
(22, 'Nuevo pedido web', 'Pedido #61 por Bs. 5011.95', '2026-08-14 05:39:00', '1', 61),
(23, 'Nuevo pedido web', 'Pedido #62 por Bs. 7325.17', '2026-08-14 07:21:00', '1', 62),
(24, 'Nuevo pedido web', 'Pedido #63 por Bs. 3084.28', '2026-08-14 07:30:00', '1', 63),
(25, 'Nuevo pedido web', 'Pedido #64 por Bs. 3084.28', '2026-08-14 07:33:00', '1', 64),
(26, 'Nuevo pedido web', 'Pedido #65 por Bs. 3084.28', '2026-08-14 07:38:00', '1', 65),
(27, 'Nuevo pedido web', 'Pedido #66 por Bs. 3084.28', '2026-08-14 07:41:00', '1', 66),
(28, 'Nuevo pedido web', 'Pedido #67 por Bs. 3624.03', '2026-08-15 12:06:00', '1', 67),
(29, 'Nuevo pedido web', 'Pedido #68 por Bs. 2698.75', '2026-08-15 07:21:00', '1', 68),
(30, 'Nuevo pedido web', 'Pedido #69 por Bs. 4240.89', '2026-08-15 07:36:00', '1', 69),
(31, 'Nuevo pedido web', 'Pedido #70 por Bs. 4240.89', '2026-08-15 07:44:00', '1', 70),
(32, 'Nuevo pedido web', 'Pedido #75 por Bs. 6615.17', '2026-08-26 10:11:00', '1', 75),
(33, 'Nuevo pedido web', 'Pedido #76 por Bs. 2913.82', '2026-08-26 10:17:00', '1', 76),
(34, 'Nueva reserva', 'Reserva #77 registrada el 2026-08-26 22:20:21', '2026-08-26 22:20:21', '1', 77),
(35, 'Nuevo pedido web', 'Pedido #78 por Bs. 2913.82', '2026-08-26 10:21:00', '1', 78),
(36, 'Nuevo pedido web', 'Pedido #79 por Bs. 2913.82', '2026-08-26 11:10:00', '1', 79),
(37, 'Nuevo pedido web', 'Pedido #80 por Bs. 5618.37', '2026-08-27 08:43:00', '1', 80),
(38, 'Nuevo pedido web', 'Pedido #81 por Bs. 2373.96', '2026-08-27 08:44:00', '1', 81),
(39, 'Nuevo pedido web', 'Pedido #82 por Bs. 47479.20', '2026-08-27 09:36:00', '1', 82),
(40, 'Nueva reserva', 'Reserva #83 registrada el 2026-08-27 21:39:03', '2026-08-27 21:39:03', '1', 83),
(41, 'Nuevo pedido web', 'Pedido #84 por Bs. 3719.20', '2026-08-27 09:44:00', '1', 84),
(42, 'Nueva reserva', 'Reserva #85 registrada el 2026-08-27 21:51:51', '2026-08-27 21:51:51', '1', 85),
(43, 'Nuevo pedido web', 'Pedido #86 por Bs. 6726.22', '2026-08-27 09:59:00', '1', 86),
(44, 'Nuevo pedido web', 'Pedido #87 por Bs. 9495.84', '2026-08-27 10:03:00', '1', 87),
(45, 'Nuevo pedido web', 'Pedido #88 por Bs. 3560.94', '2026-08-27 10:07:00', '1', 88),
(46, 'Nuevo pedido web', 'Pedido #89 por Bs. 4352.26', '2026-08-27 10:10:00', '1', 89),
(47, 'Nueva reserva', 'Reserva #90 registrada el 2026-08-27 22:13:39', '2026-08-27 22:13:39', '1', 90),
(48, 'Nuevo pedido web', 'Pedido #91 por Bs. 9495.84', '2026-08-27 10:16:00', '1', 91),
(49, 'Nuevo pedido web', 'Pedido #92 por Bs. 18596.02', '2026-08-27 10:25:00', '1', 92),
(50, 'Nuevo pedido web', 'Pedido #93 por Bs. 5934.90', '2026-08-27 10:27:00', '1', 93),
(51, 'Nueva reserva', 'Reserva #94 registrada el 2026-08-27 22:31:54', '2026-08-27 22:31:54', '1', 94),
(52, 'Nuevo pedido web', 'Pedido #95 por Bs. 8467.12', '2026-08-27 10:38:00', '1', 95),
(53, 'Nuevo pedido web', 'Pedido #96 por Bs. 6726.22', '2026-08-27 10:51:00', '1', 96),
(54, 'Nuevo pedido web', 'Pedido #97 por Bs. 2373.96', '2026-08-27 11:22:00', '1', 97),
(55, 'Nuevo pedido web', 'Pedido #103 por Bs. 8708.37', '2026-08-28 12:07:00', '1', 103),
(56, 'Nuevo pedido web', 'Pedido #113 por Bs. 7154.91', '2026-08-31 09:50:00', '1', 113),
(57, 'Nuevo pedido web', 'Pedido #114 por Bs. 2384.97', '2026-08-31 11:00:00', '1', 114),
(58, 'Nuevo pedido web', 'Pedido #115 por Bs. 2782.47', '2026-08-31 11:31:00', '1', 115),
(59, 'Nuevo pedido web', 'Pedido #116 por Bs. 2782.47', '2026-08-31 07:48:00', '1', 116),
(60, 'Nuevo pedido web', 'Pedido #117 por Bs. 13571.61', '2026-09-01 01:05:00', '1', 117),
(61, 'Nuevo pedido web', 'Pedido #118 por Bs. 3752.15', '2026-09-01 01:17:00', '1', 118),
(62, 'Nuevo pedido web', 'Pedido #119 por Bs. 5588.31', '2026-09-01 10:25:00', '1', 119),
(63, 'Nuevo pedido web', 'Pedido #120 por Bs. 16365.77', '2026-09-01 10:28:00', '1', 120),
(64, 'Nuevo pedido web', 'Pedido #121 por Bs. 7983.30', '2026-09-01 11:20:00', '1', 121),
(65, 'Nuevo pedido web', 'Pedido #122 por Bs. 27143.22', '2026-09-01 11:27:00', '1', 122),
(66, 'Nuevo pedido web', 'Pedido #123 por Bs. 3765.55', '2026-09-02 09:40:00', '1', 123),
(67, 'Nuevo pedido web', 'Pedido #124 por Bs. 3765.55', '2026-09-02 10:01:00', '1', 124),
(68, 'Nueva reserva', 'Reserva #125 registrada el 2026-09-02 22:06:08', '2026-09-02 22:06:08', '1', 125),
(69, 'Nuevo pedido web', 'Pedido #126 por Bs. 2403.54', '2026-09-02 10:11:00', '1', 126),
(70, 'Nueva reserva', 'Reserva #127 registrada el 2026-09-02 22:25:23', '2026-09-02 22:25:23', '1', 127),
(71, 'Nuevo pedido web', 'Pedido #128 por Bs. 1609.62', '2026-09-03 06:35:00', '1', 128),
(72, 'Nuevo pedido web', 'Pedido #129 por Bs. 2414.43', '2026-09-03 08:40:00', '1', 129),
(73, 'Nuevo pedido web', 'Pedido #130 por Bs. 2422.17', '2026-09-04 01:02:00', '1', 130),
(74, 'Nuevo pedido web', 'Pedido #131 por Bs. 10138.75', '2026-10-02 01:58:00', '1', 131),
(75, 'Nuevo pedido web', 'Pedido #132 por Bs. 7153.60', '2026-10-06 04:21:00', '1', 132),
(76, 'Nuevo pedido web', 'Pedido #133 por Bs. 55490.75', '2026-10-07 10:49:00', '1', 133),
(77, 'Nuevo pedido web', 'Pedido #134 por Bs. 3064.78', '2026-10-09 02:14:00', '1', 134),
(78, 'Nuevo pedido web', 'Pedido #135 por Bs. 3064.78', '2026-10-09 04:08:00', '1', 135),
(79, 'Nuevo pedido web', 'Pedido #136 por Bs. 3064.78', '2026-10-10 10:47:00', '1', 136),
(80, 'Nuevo pedido web', 'Pedido #137 por Bs. 8231.11', '2026-10-10 06:02:00', '1', 137),
(81, 'Nuevo pedido web', 'Pedido #138 por Bs. 4115.56', '2026-10-11 12:12:00', '1', 138),
(82, 'Nuevo pedido web', 'Pedido #139 por Bs. 6129.55', '2026-10-11 02:43:00', '1', 139),
(83, 'Nuevo pedido web', 'Pedido #140 por Bs. 4115.56', '2026-10-11 05:43:00', '1', 140),
(84, 'Nuevo pedido web', 'Pedido #141 por Bs. 3064.78', '2026-10-11 05:43:00', '1', 141),
(85, 'Nuevo pedido web', 'Pedido #142 por Bs. 3064.78', '2026-10-11 05:48:00', '1', 142),
(86, 'Nuevo pedido web', 'Pedido #143 por Bs. 3064.78', '2026-10-12 12:10:00', '1', 143),
(87, 'Nuevo pedido web', 'Pedido #144 por Bs. 3064.78', '2026-10-12 03:22:00', '1', 144),
(88, 'Nuevo pedido web', 'Pedido #145 por Bs. 3064.78', '2026-10-12 04:03:00', '1', 145),
(89, 'Nuevo pedido web', 'Pedido #146 por Bs. 3064.78', '2026-10-12 06:25:00', '1', 146),
(90, 'Nuevo pedido web', 'Pedido #147 por Bs. 2977.21', '2026-10-12 06:29:00', '1', 147),
(91, 'Nuevo pedido web', 'Pedido #148 por Bs. 3064.78', '2026-10-12 06:39:00', '1', 148),
(92, 'Nuevo pedido web', 'Pedido #149 por Bs. 13134.75', '2026-10-12 07:18:00', '1', 149),
(93, 'Nuevo pedido web', 'Pedido #150 por Bs. 17513.00', '2026-10-12 07:30:00', '1', 150),
(94, 'Nuevo pedido web', 'Pedido #151 por Bs. 5253.90', '2026-10-12 07:39:00', '1', 151),
(95, 'Nuevo pedido web', 'Pedido #152 por Bs. 4553.38', '2026-10-12 08:02:00', '1', 152),
(96, 'Nuevo pedido web', 'Pedido #153 por Bs. 21978.82', '2026-10-12 08:10:00', '1', 153),
(97, 'Nuevo pedido web', 'Pedido #154 por Bs. 8756.50', '2026-10-12 08:17:00', '1', 154),
(98, 'Nuevo pedido web', 'Pedido #155 por Bs. 24518.20', '2026-10-12 08:25:00', '1', 155),
(99, 'Nuevo pedido web', 'Pedido #156 por Bs. 8231.11', '2026-10-12 08:32:00', '1', 156),
(100, 'Nuevo pedido web', 'Pedido #157 por Bs. 26269.50', '2026-10-12 08:37:00', '1', 157),
(101, 'Nuevo pedido web', 'Pedido #158 por Bs. 6137.60', '2026-10-13 08:55:00', '1', 158);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido`
--

CREATE TABLE `pedido` (
  `id_pedido` int(11) NOT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `canal_origen` varchar(20) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `estatus` varchar(20) DEFAULT NULL,
  `tracking` varchar(100) DEFAULT NULL,
  `precio_total_usd` decimal(12,2) DEFAULT NULL,
  `precio_total_bs` decimal(12,2) DEFAULT NULL,
  `cedula` int(11) DEFAULT NULL,
  `id_direccion` int(11) DEFAULT NULL,
  `id_pago` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `pedido`
--

INSERT INTO `pedido` (`id_pedido`, `tipo`, `canal_origen`, `fecha`, `estatus`, `tracking`, `precio_total_usd`, `precio_total_bs`, `cedula`, `id_direccion`, `id_pago`) VALUES
(1, '2', NULL, '2026-04-21 12:46:00', '5', NULL, 12.00, 5780.40, 30716541, 1, 1),
(2, '1', NULL, '2026-04-21 23:05:51', '2', NULL, 3.00, 1445.10, 30716541, NULL, 2),
(3, '1', NULL, '2026-04-22 17:38:03', '2', NULL, 40.00, 19310.34, 30753995, NULL, 3),
(4, '1', NULL, '2026-04-22 17:41:40', '2', NULL, 41.30, 19937.93, 30753995, NULL, 4),
(5, '1', NULL, '2026-04-22 17:42:31', '2', NULL, 66.00, 31862.07, 30753995, NULL, 5),
(6, '1', NULL, '2026-04-22 17:43:54', '2', NULL, 18.00, 8689.65, 30753995, NULL, 6),
(7, '2', NULL, '2026-04-22 04:44:00', '5', NULL, 7.20, 3475.87, 30716541, 2, 7),
(8, '1', NULL, '2026-04-22 16:45:18', '2', NULL, 3.00, 1448.28, 30716541, NULL, 8),
(9, '2', NULL, '2026-04-22 04:47:00', '5', NULL, 4.70, 2268.97, 11697944, 3, 9),
(10, '2', NULL, '2026-04-22 04:48:00', '5', NULL, 17.00, 8206.92, 11547769, 4, 10),
(11, '1', NULL, '2026-04-22 16:50:56', '2', NULL, 4.00, 1931.04, 11547769, NULL, 11),
(12, '2', NULL, '2026-04-22 05:48:00', '5', NULL, 8.70, 4200.01, 30803034, 5, 12),
(13, '2', NULL, '2026-04-22 10:07:00', '5', NULL, 7.00, 3379.32, 31765947, 6, 13),
(14, '2', NULL, '2026-05-26 08:26:00', '5', NULL, 4.70, 2516.33, 30559878, 7, 14),
(15, '1', NULL, '2026-06-05 04:34:33', '2', NULL, 4.00, 2253.16, 30753995, NULL, 15),
(16, '1', NULL, '2026-07-06 16:42:15', '2', NULL, 11.30, 7537.66, 12701387, NULL, 16),
(17, '2', NULL, '2026-07-06 03:24:00', '0', NULL, 3.00, 2001.15, 25293863, 8, 18),
(18, '1', NULL, '2026-07-06 19:28:03', '2', NULL, 50.00, 33352.50, 25293863, NULL, 19),
(19, '2', NULL, '2026-07-06 03:35:00', '0', NULL, 4.00, 2668.20, 25293863, 9, 20),
(20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, 21),
(21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11, 22),
(22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12, 23),
(23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13, 24),
(24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14, 25),
(25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15, 26),
(26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, 27),
(27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17, 28),
(28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18, 29),
(29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19, 30),
(30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20, 31),
(31, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21, 32),
(32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22, 33),
(33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23, 34),
(34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24, 35),
(35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25, 36),
(36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26, 37),
(37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27, 38),
(38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28, 39),
(39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29, 40),
(40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30, 41),
(41, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31, 42),
(42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32, 43),
(43, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33, 44),
(44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34, 45),
(45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35, 46),
(46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36, 47),
(47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37, 48),
(49, '1', NULL, '2026-07-21 16:18:48', '2', NULL, 6.80, 5013.18, 29506932, NULL, 50),
(50, '1', NULL, '2026-07-21 16:19:36', '2', NULL, 40.00, 29489.28, 85700820, NULL, 51),
(51, '1', NULL, '2026-07-21 16:21:15', '2', NULL, 3.00, 2211.70, 25471240, NULL, 52),
(52, '1', NULL, '2026-07-21 18:29:15', '2', NULL, 8.00, 5897.86, 31765947, NULL, 53),
(53, '1', NULL, '2026-07-21 18:30:56', '2', NULL, 10.30, 7593.49, 30665005, NULL, 54),
(54, '1', NULL, '2026-07-21 18:33:24', '2', NULL, 13.50, 9952.63, 30759826, NULL, 55),
(55, '2', NULL, '2026-08-13 08:47:00', '0', NULL, 4.00, 10000.00, 10200300, 39, 56),
(56, '2', NULL, '2026-08-13 08:52:00', '5', '654654654546544', 5.50, 5000.00, 10200300, 40, 57),
(57, '2', NULL, '2026-08-13 09:07:00', '0', NULL, 4.00, 3067.44, 10200300, 41, 58),
(58, '2', NULL, '2026-08-14 04:44:00', '0', NULL, 5.50, 4240.89, 31271852, 42, 59),
(59, '2', NULL, '2026-08-14 05:27:00', '5', NULL, 8.30, 6399.88, 30665005, 43, 60),
(60, '2', NULL, '2026-08-14 05:33:00', '5', NULL, 7.70, 5937.24, 30665005, 44, 61),
(61, '2', NULL, '2026-08-14 05:39:00', '5', NULL, 6.50, 5011.95, 29997994, 45, 62),
(62, '2', NULL, '2026-08-14 07:21:00', '0', NULL, 9.50, 7325.17, 10200300, 46, 63),
(63, '2', NULL, '2026-08-14 07:30:00', '5', NULL, 4.00, 3084.28, 10200300, 47, 64),
(64, '2', NULL, '2026-08-14 07:33:00', '0', NULL, 4.00, 3084.28, 10200300, 48, 65),
(65, '2', NULL, '2026-08-14 07:38:00', '5', NULL, 4.00, 3084.28, 10200300, 49, 66),
(66, '2', NULL, '2026-08-14 07:41:00', '0', NULL, 4.00, 3084.28, 10200300, 50, 67),
(67, '2', NULL, '2026-08-15 12:06:00', '5', NULL, 4.70, 3624.03, 30559878, 51, 68),
(68, '2', NULL, '2026-08-15 07:21:00', '5', NULL, 3.50, 2698.75, 30716541, 52, 69),
(69, '2', NULL, '2026-08-15 07:36:00', '5', NULL, 5.50, 4240.89, 30716541, 53, 70),
(70, '2', NULL, '2026-08-15 07:44:00', '5', NULL, 5.50, 4240.89, 12241103, 54, 71),
(71, '1', NULL, '2026-08-20 20:39:30', '2', NULL, 42.00, 32651.48, 30621851, NULL, 72),
(72, '1', NULL, '2026-08-20 20:40:14', '2', NULL, 7.00, 5441.91, 27667215, NULL, 73),
(73, '1', NULL, '2026-08-20 20:43:22', '2', NULL, 6.00, 4664.50, 33466179, NULL, 74),
(74, '1', NULL, '2026-08-20 20:44:06', '2', NULL, 5.50, 4275.79, 28539535, NULL, 75),
(75, '2', NULL, '2026-08-26 10:11:00', '0', NULL, 8.40, 6615.17, 31765947, 55, 76),
(76, '2', NULL, '2026-08-26 10:17:00', '5', NULL, 3.70, 2913.82, 31765947, 56, 77),
(77, '1', NULL, '2026-08-26 22:20:21', '2', NULL, 5.50, 4331.36, 31765947, NULL, 78),
(78, '2', NULL, '2026-08-26 10:21:00', '5', NULL, 3.70, 2913.82, 31765947, 57, 79),
(79, '2', NULL, '2026-08-26 11:10:00', '0', NULL, 3.70, 2913.82, 31765947, 58, 80),
(80, '2', NULL, '2026-08-27 08:43:00', '5', NULL, 7.10, 5618.37, 16210068, 59, 81),
(81, '2', NULL, '2026-08-27 08:44:00', '5', NULL, 3.00, 2373.96, 16210068, 60, 82),
(82, '2', NULL, '2026-08-27 09:36:00', '5', NULL, 60.00, 47479.20, 16210068, 61, 83),
(83, '1', NULL, '2026-08-27 21:39:03', '2', NULL, 3.00, 2373.96, 16210068, NULL, 84),
(84, '2', NULL, '2026-08-27 09:44:00', '5', NULL, 4.70, 3719.20, 29762707, 62, 85),
(85, '3', NULL, '2026-08-27 21:51:51', '0', NULL, 6.50, 5143.58, 31550323, NULL, 86),
(86, '2', NULL, '2026-08-27 09:59:00', '5', NULL, 8.50, 6726.22, 21459699, 63, 87),
(87, '2', NULL, '2026-08-27 10:03:00', '5', NULL, 12.00, 9495.84, 21129740, 64, 88),
(88, '2', NULL, '2026-08-27 10:07:00', '0', NULL, 4.50, 3560.94, 30673077, 65, 89),
(89, '2', NULL, '2026-08-27 10:10:00', '5', NULL, 5.50, 4352.26, 30318119, 66, 90),
(90, '1', NULL, '2026-08-27 22:13:39', '2', NULL, 10.00, 7913.20, 30601595, NULL, 91),
(91, '2', NULL, '2026-08-27 10:16:00', '5', NULL, 12.00, 9495.84, 11269334, 67, 92),
(92, '2', NULL, '2026-08-27 10:25:00', '5', NULL, 23.50, 18596.02, 21141772, 68, 93),
(93, '2', NULL, '2026-08-27 10:27:00', '5', NULL, 7.50, 5934.90, 20186429, 69, 94),
(94, '3', NULL, '2026-08-27 22:31:54', '1', NULL, 6.50, 5143.58, 30759451, NULL, 95),
(95, '2', NULL, '2026-08-27 10:38:00', '5', NULL, 10.70, 8467.12, 29945119, 70, 96),
(96, '2', NULL, '2026-08-27 10:51:00', '5', '010801306000371', 8.50, 6726.22, 30803034, 71, 97),
(97, '2', NULL, '2026-08-27 11:22:00', '5', NULL, 3.00, 2373.96, 30266662, 72, 98),
(98, '1', NULL, '2026-08-28 03:30:58', '2', NULL, 6.00, 4747.95, 30266662, NULL, 99),
(99, '1', NULL, '2026-08-28 03:31:40', '2', NULL, 9.50, 7517.59, 29945119, NULL, 100),
(100, '1', NULL, '2026-08-28 03:32:19', '2', NULL, 4.70, 3719.23, 29805480, NULL, 101),
(101, '1', NULL, '2026-08-28 03:34:33', '2', NULL, 13.50, 10682.88, 29506932, NULL, 102),
(102, '1', NULL, '2026-08-28 03:35:33', '2', NULL, 10.00, 7913.25, 30759451, NULL, 104),
(103, '2', NULL, '2026-08-28 12:07:00', '2', NULL, 11.00, 8708.37, 11697944, 73, 105),
(104, '1', NULL, '2026-08-30 03:55:17', '2', NULL, 4.00, 3166.67, 85700820, NULL, 106),
(105, '1', NULL, '2026-08-30 03:55:57', '2', NULL, 9.00, 7125.00, 33466179, NULL, 107),
(106, '1', NULL, '2026-08-30 03:57:42', '2', NULL, 11.50, 9104.17, 11269334, NULL, 108),
(107, '1', NULL, '2026-08-30 03:58:26', '2', NULL, 9.50, 7520.83, 20186429, NULL, 110),
(108, '1', NULL, '2026-08-31 02:17:59', '2', NULL, 18.00, 14250.00, 28653562, NULL, 111),
(109, '1', NULL, '2026-08-31 02:20:41', '2', NULL, 7.50, 5937.50, 20186429, NULL, 112),
(110, '1', NULL, '2026-08-31 02:21:32', '2', NULL, 2.50, 1979.17, 11269334, NULL, 114),
(111, '1', NULL, '2026-08-31 02:23:06', '2', NULL, 19.00, 15041.67, 21459699, NULL, 116),
(112, '1', NULL, '2026-08-31 02:23:43', '2', NULL, 9.40, 7441.67, 21141772, NULL, 118),
(113, '2', NULL, '2026-08-31 09:50:00', '1', NULL, 9.00, 7154.91, 30559878, 74, 119),
(114, '2', NULL, '2026-08-31 11:00:00', '1', NULL, 3.00, 2384.97, 10200300, 75, 120),
(115, '2', NULL, '2026-08-31 11:31:00', '1', NULL, 3.50, 2782.47, 10200300, 76, 121),
(116, '2', NULL, '2026-08-31 07:48:00', '1', NULL, 3.50, 2782.47, 10200300, 77, 122),
(117, '2', NULL, '2026-09-01 01:05:00', '1', NULL, 17.00, 13571.61, 31765947, 78, 123),
(118, '2', NULL, '2026-09-01 01:17:00', '0', NULL, 4.70, 3752.15, 31765947, 79, 124),
(119, '2', NULL, '2026-09-01 10:25:00', '5', NULL, 7.00, 5588.31, 30301154, 80, 125),
(120, '2', NULL, '2026-09-01 10:28:00', '1', NULL, 20.50, 16365.77, 30301154, 81, 126),
(121, '2', NULL, '2026-09-01 11:20:00', '1', NULL, 10.00, 7983.30, 29945088, 82, 127),
(122, '2', NULL, '2026-09-01 11:27:00', '1', NULL, 34.00, 27143.22, 29945088, 83, 128),
(123, '2', NULL, '2026-09-02 09:40:00', '1', NULL, 4.70, 3765.55, 30559878, 84, 129),
(124, '2', NULL, '2026-09-02 10:01:00', '1', NULL, 4.70, 3765.55, 30559878, 85, 130),
(125, '3', NULL, '2026-09-02 22:06:08', '1', NULL, 5.50, 4406.49, 30559878, NULL, 131),
(126, '2', NULL, '2026-09-02 10:11:00', '0', NULL, 3.00, 2403.54, 10200300, 86, 132),
(127, '3', NULL, '2026-09-02 22:25:23', '1', NULL, 5.50, 4406.49, 30559878, NULL, 133),
(128, '2', NULL, '2026-09-03 06:35:00', '5', NULL, 2.00, 1609.62, 30716541, 87, 134),
(129, '2', NULL, '2026-09-03 08:40:00', '0', NULL, 3.00, 2414.43, 10200300, 88, 135),
(130, '2', NULL, '2026-09-04 01:02:00', '5', NULL, 3.00, 2422.17, 31271852, 89, 136),
(131, '2', NULL, '2026-10-02 01:58:00', '1', NULL, 11.70, 10138.75, 10200300, 90, 137),
(132, '2', NULL, '2026-10-06 04:21:00', '1', NULL, 8.20, 7153.60, 30716541, 91, 138),
(133, '2', NULL, '2026-10-07 10:49:00', '1', NULL, 63.50, 55490.75, 15691374, 92, 139),
(134, '2', NULL, '2026-10-09 02:14:00', '1', NULL, 3.50, 3064.78, 30716541, 93, 140),
(135, '2', NULL, '2026-10-09 04:08:00', '5', NULL, 3.50, 3064.78, 14335762, 94, 141),
(136, '2', NULL, '2026-10-10 10:47:00', '5', NULL, 3.50, 3064.78, 31271852, 95, 142),
(137, '2', NULL, '2026-10-10 06:02:00', '1', NULL, 9.40, 8231.11, 10200300, 96, 143),
(138, '2', NULL, '2026-10-11 12:12:00', '1', NULL, 4.70, 4115.56, 32063438, 97, 144),
(139, '2', NULL, '2026-10-11 02:43:00', '1', NULL, 7.00, 6129.55, 10200300, 98, 145),
(140, '2', NULL, '2026-10-11 05:43:00', '1', NULL, 4.70, 4115.56, 30716541, 99, 146),
(141, '2', NULL, '2026-10-11 05:43:00', '1', NULL, 3.50, 3064.78, 27349943, 100, 147),
(142, '2', NULL, '2026-10-11 05:48:00', '1', NULL, 3.50, 3064.78, 30716541, 101, 148),
(143, '2', NULL, '2026-10-12 12:10:00', '5', NULL, 3.50, 3064.78, 10200300, 102, 149),
(144, '2', NULL, '2026-10-12 03:22:00', '5', NULL, 3.50, 3064.78, 30753995, 103, 150),
(145, '2', NULL, '2026-10-12 04:03:00', '5', NULL, 3.50, 3064.78, 30753995, 104, 151),
(146, '2', NULL, '2026-10-12 06:25:00', '5', NULL, 3.50, 3064.78, 30716541, 105, 152),
(147, '2', NULL, '2026-10-12 06:29:00', '3', '654654654546544', 3.40, 2977.21, 30716541, 106, 153),
(148, '2', NULL, '2026-10-12 06:39:00', '5', NULL, 3.50, 3064.78, 30716541, 107, 154),
(149, '2', NULL, '2026-10-12 07:18:00', '4', NULL, 15.00, 13134.75, 30716541, 108, 155),
(150, '2', NULL, '2026-10-12 07:30:00', '5', NULL, 20.00, 17513.00, 30716541, 109, 156),
(151, '2', NULL, '2026-10-12 07:39:00', '5', NULL, 6.00, 5253.90, 11697944, 110, 157),
(152, '2', NULL, '2026-10-12 08:02:00', '5', NULL, 5.20, 4553.38, 30301154, 111, 158),
(153, '2', NULL, '2026-10-12 08:10:00', '1', NULL, 25.10, 21978.82, 30301154, 112, 159),
(154, '2', NULL, '2026-10-12 08:17:00', '5', NULL, 10.00, 8756.50, 30601595, 113, 160),
(155, '2', NULL, '2026-10-12 08:25:00', '2', NULL, 28.00, 24518.20, 30601595, 114, 161),
(156, '2', NULL, '2026-10-12 08:32:00', '5', NULL, 9.40, 8231.11, 30673077, 115, 162),
(157, '2', NULL, '2026-10-12 08:37:00', '5', NULL, 30.00, 26269.50, 30673077, 116, 163),
(158, '2', NULL, '2026-10-13 08:55:00', '2', NULL, 7.00, 6137.60, 30559878, 117, 164),
(159, '1', NULL, '2026-10-15 22:51:54', '2', NULL, 5.00, 4395.61, 30753995, NULL, 165),
(160, '1', NULL, '2026-10-16 02:29:57', '2', NULL, 5.00, 4395.61, 30753995, NULL, 166),
(161, '1', NULL, '2026-10-16 03:39:04', '2', NULL, 5.00, 4395.61, 30753995, NULL, 167);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido_detalles`
--

CREATE TABLE `pedido_detalles` (
  `id_detalle` int(11) NOT NULL,
  `id_pedido` int(11) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio_unitario` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `pedido_detalles`
--

INSERT INTO `pedido_detalles` (`id_detalle`, `id_pedido`, `id_producto`, `cantidad`, `precio_unitario`) VALUES
(1, 1, 5, 1, 12.00),
(2, 2, 8, 1, 3.00),
(3, 3, 9, 10, 4.00),
(4, 4, 7, 7, 3.40),
(5, 4, 11, 5, 3.50),
(6, 5, 10, 12, 5.50),
(7, 6, 8, 6, 3.00),
(8, 7, 6, 1, 3.70),
(9, 7, 11, 1, 3.50),
(10, 8, 8, 1, 3.00),
(11, 9, 5, 1, 4.70),
(12, 10, 12, 2, 8.50),
(13, 11, 9, 1, 4.00),
(14, 12, 5, 1, 4.70),
(15, 12, 14, 1, 4.00),
(16, 13, 8, 1, 3.00),
(17, 13, 9, 1, 4.00),
(18, 14, 5, 1, 4.70),
(19, 15, 9, 1, 4.00),
(20, 16, 9, 2, 4.00),
(21, 16, 17, 1, 3.30),
(22, 17, 8, 1, 3.00),
(23, 18, 9, 4, 4.00),
(24, 18, 12, 4, 8.50),
(25, 19, 9, 1, 4.00),
(27, 49, 7, 2, 3.40),
(28, 50, 9, 10, 4.00),
(29, 51, 8, 1, 3.00),
(30, 52, 9, 2, 4.00),
(31, 53, 17, 1, 3.30),
(32, 53, 14, 1, 4.00),
(33, 53, 13, 1, 3.00),
(34, 54, 14, 2, 4.00),
(35, 54, 16, 1, 5.50),
(36, 55, 9, 1, 4.00),
(37, 56, 10, 1, 5.50),
(38, 57, 9, 1, 4.00),
(39, 58, 10, 1, 5.50),
(40, 59, 17, 1, 3.30),
(41, 59, 18, 1, 5.00),
(42, 60, 8, 1, 3.00),
(43, 60, 5, 1, 4.70),
(44, 61, 11, 1, 3.50),
(45, 61, 8, 1, 3.00),
(46, 62, 9, 1, 4.00),
(47, 62, 10, 1, 5.50),
(48, 63, 9, 1, 4.00),
(49, 64, 9, 1, 4.00),
(50, 65, 9, 1, 4.00),
(51, 66, 9, 1, 4.00),
(52, 67, 5, 1, 4.70),
(53, 68, 11, 1, 3.50),
(54, 69, 10, 1, 5.50),
(55, 70, 10, 1, 5.50),
(56, 71, 20, 1, 42.00),
(57, 72, 11, 2, 3.50),
(58, 73, 26, 2, 3.00),
(59, 74, 8, 1, 3.00),
(60, 74, 25, 1, 2.50),
(61, 75, 5, 1, 4.70),
(62, 75, 6, 1, 3.70),
(63, 76, 6, 1, 3.70),
(64, 77, 10, 1, 5.50),
(65, 78, 6, 1, 3.70),
(66, 79, 6, 1, 3.70),
(67, 80, 7, 1, 3.40),
(68, 80, 6, 1, 3.70),
(69, 81, 29, 1, 3.00),
(70, 82, 22, 1, 18.00),
(71, 82, 20, 1, 42.00),
(72, 83, 8, 1, 3.00),
(73, 84, 5, 1, 4.70),
(74, 85, 31, 1, 6.50),
(75, 86, 25, 1, 2.50),
(76, 86, 29, 1, 3.00),
(77, 86, 26, 1, 3.00),
(78, 87, 30, 1, 4.00),
(79, 87, 29, 1, 3.00),
(80, 87, 12, 1, 5.00),
(81, 88, 14, 3, 1.50),
(82, 89, 14, 1, 1.50),
(83, 89, 18, 1, 4.00),
(84, 90, 27, 5, 2.00),
(85, 91, 10, 1, 5.50),
(86, 91, 31, 1, 6.50),
(87, 92, 29, 1, 3.00),
(88, 92, 28, 2, 2.50),
(89, 92, 27, 1, 2.00),
(90, 92, 26, 1, 3.00),
(91, 92, 30, 1, 4.00),
(92, 92, 31, 1, 6.50),
(93, 93, 14, 5, 1.50),
(94, 94, 31, 1, 6.50),
(95, 95, 6, 1, 3.70),
(96, 95, 16, 1, 5.50),
(97, 95, 14, 1, 1.50),
(98, 96, 16, 1, 5.50),
(99, 96, 8, 1, 3.00),
(100, 97, 35, 1, 3.00),
(101, 98, 36, 1, 6.00),
(102, 99, 16, 1, 5.50),
(103, 99, 33, 1, 4.00),
(104, 100, 5, 1, 4.70),
(105, 101, 34, 1, 3.50),
(106, 101, 12, 2, 5.00),
(107, 102, 27, 2, 2.00),
(108, 102, 26, 2, 3.00),
(109, 103, 37, 1, 11.00),
(110, 104, 27, 2, 2.00),
(111, 105, 36, 1, 6.00),
(112, 105, 8, 1, 3.00),
(113, 106, 35, 1, 3.00),
(114, 106, 12, 1, 5.00),
(115, 106, 34, 1, 3.50),
(116, 107, 42, 2, 3.00),
(117, 107, 41, 1, 3.50),
(118, 108, 22, 1, 18.00),
(119, 109, 25, 1, 2.50),
(120, 109, 12, 1, 5.00),
(121, 110, 28, 1, 2.50),
(122, 111, 8, 1, 3.00),
(123, 111, 36, 1, 6.00),
(124, 111, 28, 2, 2.50),
(125, 111, 11, 1, 5.00),
(126, 112, 5, 2, 4.70),
(127, 113, 8, 3, 3.00),
(128, 114, 8, 1, 3.00),
(129, 115, 9, 1, 3.50),
(130, 116, 9, 1, 3.50),
(131, 117, 7, 5, 3.40),
(132, 118, 5, 1, 4.70),
(133, 119, 11, 1, 5.00),
(134, 119, 58, 1, 2.00),
(135, 120, 24, 1, 5.00),
(136, 120, 25, 2, 2.50),
(137, 120, 29, 1, 3.00),
(138, 120, 32, 1, 3.50),
(139, 120, 33, 1, 4.00),
(140, 121, 55, 5, 2.00),
(141, 122, 54, 2, 2.50),
(142, 122, 55, 2, 2.00),
(143, 122, 57, 2, 2.00),
(144, 122, 56, 2, 2.50),
(145, 122, 58, 2, 2.00),
(146, 122, 59, 2, 2.00),
(147, 122, 60, 2, 2.00),
(148, 122, 61, 2, 2.00),
(149, 123, 5, 1, 4.70),
(150, 124, 5, 1, 4.70),
(151, 125, 10, 1, 5.50),
(152, 126, 8, 1, 3.00),
(153, 127, 10, 1, 5.50),
(154, 128, 27, 1, 2.00),
(155, 129, 8, 1, 3.00),
(156, 130, 8, 1, 3.00),
(157, 131, 9, 2, 3.50),
(158, 131, 5, 1, 4.70),
(159, 132, 5, 1, 4.70),
(160, 132, 13, 1, 3.50),
(161, 133, 22, 2, 16.00),
(162, 133, 60, 1, 2.00),
(163, 133, 58, 1, 2.00),
(164, 133, 61, 1, 2.00),
(165, 133, 23, 2, 5.00),
(166, 133, 28, 1, 2.50),
(167, 133, 32, 1, 3.50),
(168, 133, 38, 1, 3.50),
(169, 133, 52, 1, 2.50),
(170, 133, 9, 1, 3.50),
(171, 134, 9, 1, 3.50),
(172, 135, 9, 1, 3.50),
(173, 136, 9, 1, 3.50),
(174, 137, 5, 2, 4.70),
(175, 138, 5, 1, 4.70),
(176, 139, 9, 2, 3.50),
(177, 140, 5, 1, 4.70),
(178, 141, 9, 1, 3.50),
(179, 142, 9, 1, 3.50),
(180, 143, 9, 1, 3.50),
(181, 144, 9, 1, 3.50),
(182, 145, 9, 1, 3.50),
(183, 146, 9, 1, 3.50),
(184, 147, 7, 1, 3.40),
(185, 148, 9, 1, 3.50),
(186, 149, 23, 1, 5.00),
(187, 149, 25, 4, 2.50),
(188, 150, 11, 4, 5.00),
(189, 151, 14, 4, 1.50),
(190, 152, 19, 2, 2.60),
(191, 153, 6, 3, 3.70),
(192, 153, 13, 4, 3.50),
(193, 154, 11, 2, 5.00),
(194, 155, 9, 8, 3.50),
(195, 156, 5, 2, 4.70),
(196, 157, 26, 10, 3.00),
(197, 158, 9, 2, 3.50),
(198, 159, 44, 1, 5.00),
(199, 160, 44, 1, 5.00),
(200, 161, 44, 1, 5.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `id_producto` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `cantidad_mayor` int(11) DEFAULT NULL,
  `precio_mayor` decimal(10,2) DEFAULT NULL,
  `precio_detal` decimal(10,2) DEFAULT NULL,
  `stock_disponible` int(11) DEFAULT NULL,
  `stock_minimo` int(11) DEFAULT NULL,
  `stock_maximo` int(11) DEFAULT NULL,
  `estatus` int(1) DEFAULT 1,
  `id_categoria` int(11) DEFAULT NULL,
  `id_marca` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`id_producto`, `nombre`, `descripcion`, `cantidad_mayor`, `precio_mayor`, `precio_detal`, `stock_disponible`, `stock_minimo`, `stock_maximo`, `estatus`, `id_categoria`, `id_marca`) VALUES
(5, 'Lip glaze', 'Labial para la resequedad', 12, 3.70, 4.70, 80, 5, 100, 1, 4, 2),
(6, 'Lipgloss dije tacon', 'Productos originales', 12, 2.70, 3.70, 22, 6, 100, 1, 4, 2),
(7, 'Lip Balm macadamia', 'producto original, por unidad', 12, 2.40, 3.40, 58, 4, 100, 1, 4, 2),
(8, 'Polvo sencillo', 'Productos originales', 12, 2.30, 3.00, 18, 5, 100, 1, 1, 3),
(9, 'Lip oil bear', 'producto original', 12, 2.90, 3.50, 39, 10, 500, 1, 4, 29),
(10, 'Corrector', 'Producto original', 6, 3.50, 5.50, 121, 10, 800, 1, 6, 6),
(11, 'Gel fijador de cejas', 'Pestañas más negras y largas sin grumos.', 12, 4.00, 5.00, 142, 10, 800, 1, 11, 3),
(12, 'Base Matte', 'Alta cobertura, es de larga duración y de acabado matte', 12, 4.00, 5.00, 39, 10, 100, 1, 2, 6),
(13, 'Labial velvet', 'Producto original\r\nLe brindará una hidratación a tus labios además sus tonos son bellísimos', 12, 2.80, 3.50, 192, 10, 800, 1, 4, 3),
(14, 'Tinta de labios', 'Es de larga duración y sus tonos son preciosos', 12, 1.20, 1.50, 85, 10, 100, 1, 4, 2),
(15, 'Chicharron', 'Piel de marrano frita en su misma manteca', 20, 4.00, 5.00, 0, 10, 50, 0, 12, 16),
(16, 'Lip combo', 'producto original', 12, 4.50, 5.50, 46, 5, 200, 1, 4, 3),
(17, 'Jelly Tint', 'Productos originales', 12, 2.30, 3.30, 47, 4, 150, 1, 4, 2),
(18, 'Máscara de pestañas', 'Productos Originales', 12, 3.15, 4.00, 58, 2, 120, 1, 11, 6),
(19, 'Rizador de pestañas', 'Productos originales', 12, 1.60, 2.60, 18, 2, 100, 1, 11, 27),
(20, 'BOX glam', 'producto original', 12, 38.00, 42.00, 10, 3, 100, 1, 3, 3),
(21, 'Blush corazon dos tonos', 'productos originales', 12, 3.20, 4.00, 20, 10, 100, 1, 8, 2),
(22, 'Kit de skincare rice', 'producto original', 12, 16.00, 18.00, 16, 5, 100, 1, 32, 28),
(23, 'Kit para laminar cejas', 'producto original', 12, 4.10, 5.00, 22, 10, 100, 1, 31, 23),
(24, 'Corrector hidratante', 'producto original', 12, 4.40, 5.00, 22, 4, 100, 1, 6, 3),
(25, 'Brochas individuales', 'producto original', 6, 1.95, 2.50, 21, 2, 100, 1, 3, 30),
(26, 'Lipgloss marble', 'producto original', 12, 2.30, 3.00, 4, 5, 100, 1, 4, 29),
(27, 'Hojas absorbentes de grasa', 'producto original', 12, 1.60, 2.00, 28, 5, 100, 1, 32, 29),
(28, 'Fijador de cejas', 'producto original', 12, 1.90, 2.50, 24, 2, 100, 1, 31, 23),
(29, 'Blush smile', 'producto original', 12, 2.30, 3.00, 25, 2, 100, 1, 8, 2),
(30, 'Blush Love', 'producto original', 12, 3.10, 4.00, 13, 2, 100, 1, 8, 30),
(31, 'Blush vergüenza', 'producto original', 12, 5.80, 6.50, 21, 5, 100, 1, 8, 30),
(32, 'Gel de cejas con color', 'Productos originales', 12, 3.00, 3.50, 46, 2, 100, 1, 31, 2),
(33, 'Parches para acne', 'Productos originales, contienda 36 pcs', 12, 3.40, 4.00, 22, 6, 100, 1, 32, 2),
(34, 'Blush llaver', 'producto original, unidad', 12, 2.85, 3.50, 22, 5, 100, 1, 8, 2),
(35, 'Blush check', 'producto original', 12, 2.35, 3.00, 18, 5, 100, 1, 8, 2),
(36, 'Polvo suelto premium', 'producto original', 12, 5.00, 6.00, 17, 3, 100, 1, 1, 3),
(37, 'Paleta premium', 'producto original', 12, 9.00, 11.00, 19, 5, 100, 1, 3, 3),
(38, 'Crema retinol', 'producto original', 12, 2.80, 3.50, 23, 2, 100, 1, 32, 28),
(39, 'Máscara princess', 'producto original', 12, 1.90, 2.50, 48, 6, 150, 1, 11, 2),
(40, 'Lip oil coco', 'producto original', 12, 1.90, 2.50, 48, 6, 100, 1, 4, 23),
(41, 'Crema facial cuatro en uno', 'producto original', 12, 2.80, 3.50, 23, 6, 100, 1, 32, 28),
(42, 'Limpiador facial niacinamida', 'producto original', 12, 2.00, 3.00, 22, 5, 100, 1, 32, 28),
(43, 'Serum retinol', 'producto original', 12, 1.80, 2.50, 24, 6, 100, 1, 32, 28),
(44, 'Bálsamo premium', 'producto original', 12, 4.00, 5.00, 21, 6, 100, 1, 4, 3),
(45, 'Paleta de contorno', 'productos originales', 12, 4.20, 5.00, 24, 6, 100, 1, 3, 3),
(46, 'Blush en crema velvet', 'producto original', 12, 4.00, 5.00, 24, 6, 120, 1, 8, 15),
(47, 'Lipgloss mágico', 'producto original', 12, 2.50, 3.00, 24, 6, 120, 1, 4, 3),
(48, 'Aceite cuatro en uno', 'Productos originales', 12, 6.50, 7.50, 24, 6, 120, 1, 11, 12),
(49, 'Máscara prosa crystal protein', 'producto original', 12, 5.50, 6.50, 24, 4, 100, 1, 11, 12),
(50, 'salamo', 'producto original', 12, 3.00, 4.00, 24, 5, 100, 1, 4, 31),
(51, 'Lip combo', 'producto original', 12, 3.70, 4.50, 24, 12, 100, 1, 4, 30),
(52, 'Parches para acne', 'producto original', 12, 1.80, 2.50, 23, 2, 100, 1, 32, 28),
(53, 'Lipgloss con aplicador', 'producto original', 12, 3.40, 4.00, 36, 6, 100, 1, 4, 6),
(54, 'Lipgloss glow', 'producto original', 12, 1.80, 2.50, 34, 6, 100, 1, 4, 23),
(55, 'Lip oil colores', 'producto original', 12, 1.60, 2.00, 29, 10, 100, 1, 4, 29),
(56, 'Lipgloss starlight', 'producto original', 12, 1.65, 2.50, 22, 5, 100, 1, 4, 23),
(57, 'Lip oil glow', 'producto original', 12, 1.65, 2.00, 22, 2, 100, 1, 4, 29),
(58, 'Mascara', 'producto original', 12, 1.15, 2.00, 32, 10, 100, 1, 11, 29),
(59, 'Blush colorete', 'producto original', 12, 1.35, 2.00, 22, 5, 100, 1, 8, 2),
(60, 'Lipgloss Lucida', 'producto original', 12, 1.50, 2.00, 21, 10, 100, 1, 4, 2),
(61, 'Lipgloss tapa dorada', 'producto original', 12, 1.50, 2.00, 21, 2, 100, 1, 4, 2),
(62, 'Labial Matte Velvet', 'Labial de larga duración con acabado mate y textura suave.', 10, 10.00, 12.50, 0, 10, 100, 1, 4, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_imagen`
--

CREATE TABLE `producto_imagen` (
  `id_imagen` int(11) NOT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `url_imagen` text DEFAULT NULL,
  `public_id` varchar(255) DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `producto_imagen`
--

INSERT INTO `producto_imagen` (`id_imagen`, `id_producto`, `url_imagen`, `public_id`, `tipo`) VALUES
(246, 5, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788299105/lovemakeup/productos/fnxrwgds6caxsxo5nijv.jpg', 'lovemakeup/productos/fnxrwgds6caxsxo5nijv', 'principal'),
(247, 5, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788299106/lovemakeup/productos/ixir5ag9hityx1zlcu0y.jpg', 'lovemakeup/productos/ixir5ag9hityx1zlcu0y', 'secundaria'),
(248, 5, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788299107/lovemakeup/productos/tx8xbohui5zhljpoihvk.jpg', 'lovemakeup/productos/tx8xbohui5zhljpoihvk', 'secundaria'),
(249, 5, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788299107/lovemakeup/productos/crxxe3ittfk3xt2a3ylg.jpg', 'lovemakeup/productos/crxxe3ittfk3xt2a3ylg', 'secundaria'),
(250, 5, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788299108/lovemakeup/productos/jnjc6nhsavcl15zyx42n.jpg', 'lovemakeup/productos/jnjc6nhsavcl15zyx42n', 'secundaria'),
(251, 6, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788299201/lovemakeup/productos/sfiujgmthqej0q7izbwa.jpg', 'lovemakeup/productos/sfiujgmthqej0q7izbwa', 'principal'),
(252, 6, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788299202/lovemakeup/productos/biz4uiocmdjjuh1sqxez.jpg', 'lovemakeup/productos/biz4uiocmdjjuh1sqxez', 'secundaria'),
(253, 7, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788299275/lovemakeup/productos/gcykvlpy0lqskkc79ddm.png', 'lovemakeup/productos/gcykvlpy0lqskkc79ddm', 'principal'),
(254, 8, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788306878/lovemakeup/productos/e2mb7ddxppomzuuvwgjb.png', 'lovemakeup/productos/e2mb7ddxppomzuuvwgjb', 'principal'),
(255, 8, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788306879/lovemakeup/productos/gs8kfwxhpj9onjzrjjts.png', 'lovemakeup/productos/gs8kfwxhpj9onjzrjjts', 'secundaria'),
(256, 9, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788306969/lovemakeup/productos/sv1qvvwuzgem9e6vsfl9.png', 'lovemakeup/productos/sv1qvvwuzgem9e6vsfl9', 'principal'),
(257, 10, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788307124/lovemakeup/productos/gdfd2nx7hv53l6bwrgfc.jpg', 'lovemakeup/productos/gdfd2nx7hv53l6bwrgfc', 'principal'),
(258, 10, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788307125/lovemakeup/productos/h5yrdjiav6qrvz2zgbvs.jpg', 'lovemakeup/productos/h5yrdjiav6qrvz2zgbvs', 'secundaria'),
(259, 11, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788307183/lovemakeup/productos/qepcjhjc2j7l2qxubtoz.jpg', 'lovemakeup/productos/qepcjhjc2j7l2qxubtoz', 'principal'),
(260, 12, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788307282/lovemakeup/productos/qnqrosnlheoqs4m4rrz7.jpg', 'lovemakeup/productos/qnqrosnlheoqs4m4rrz7', 'principal'),
(261, 12, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788307283/lovemakeup/productos/penltvxjejbvbgne7rpq.jpg', 'lovemakeup/productos/penltvxjejbvbgne7rpq', 'secundaria'),
(262, 13, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788307387/lovemakeup/productos/ebl5dyp5eekhsvlbv1ju.jpg', 'lovemakeup/productos/ebl5dyp5eekhsvlbv1ju', 'principal'),
(263, 13, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788307388/lovemakeup/productos/bcz33beqnrxwus3ytjmf.jpg', 'lovemakeup/productos/bcz33beqnrxwus3ytjmf', 'secundaria'),
(264, 14, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788307442/lovemakeup/productos/nqsr76gwcgcju0ytwdi8.jpg', 'lovemakeup/productos/nqsr76gwcgcju0ytwdi8', 'principal'),
(265, 14, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788307443/lovemakeup/productos/mowacjbl4ekzqmzbz6za.jpg', 'lovemakeup/productos/mowacjbl4ekzqmzbz6za', 'secundaria'),
(266, 16, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308135/lovemakeup/productos/evmssn09ebtplmdme60z.png', 'lovemakeup/productos/evmssn09ebtplmdme60z', 'principal'),
(267, 17, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308188/lovemakeup/productos/zymipuohtkglnkmup52j.png', 'lovemakeup/productos/zymipuohtkglnkmup52j', 'principal'),
(268, 17, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308188/lovemakeup/productos/iljsodxm9m6bi1wrzzsu.png', 'lovemakeup/productos/iljsodxm9m6bi1wrzzsu', 'secundaria'),
(269, 18, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308227/lovemakeup/productos/xbsljbpguj3xpgqlzijj.png', 'lovemakeup/productos/xbsljbpguj3xpgqlzijj', 'principal'),
(270, 19, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308287/lovemakeup/productos/d4mia3hdvizlkvnlp89o.png', 'lovemakeup/productos/d4mia3hdvizlkvnlp89o', 'principal'),
(271, 20, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308344/lovemakeup/productos/g0nci6ycnnskbbw5am9t.jpg', 'lovemakeup/productos/g0nci6ycnnskbbw5am9t', 'principal'),
(272, 20, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308345/lovemakeup/productos/jpvgtycgabe1pdotyhef.jpg', 'lovemakeup/productos/jpvgtycgabe1pdotyhef', 'secundaria'),
(273, 20, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308346/lovemakeup/productos/engcisimwanad8vk1pwg.jpg', 'lovemakeup/productos/engcisimwanad8vk1pwg', 'secundaria'),
(274, 20, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308347/lovemakeup/productos/iruvusmpaso7j1qskrju.jpg', 'lovemakeup/productos/iruvusmpaso7j1qskrju', 'secundaria'),
(275, 21, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308394/lovemakeup/productos/y0pnbb8r3li1gzphqxkr.jpg', 'lovemakeup/productos/y0pnbb8r3li1gzphqxkr', 'principal'),
(276, 21, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308395/lovemakeup/productos/yu8rfinj4she4iqirhpd.jpg', 'lovemakeup/productos/yu8rfinj4she4iqirhpd', 'secundaria'),
(277, 22, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308450/lovemakeup/productos/v4r2ie4ri7cgnagvwfxm.png', 'lovemakeup/productos/v4r2ie4ri7cgnagvwfxm', 'principal'),
(278, 23, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308505/lovemakeup/productos/szsxauzklkintw4edcls.png', 'lovemakeup/productos/szsxauzklkintw4edcls', 'principal'),
(279, 24, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308556/lovemakeup/productos/dxqfulkbwunfpv4anvba.jpg', 'lovemakeup/productos/dxqfulkbwunfpv4anvba', 'principal'),
(280, 24, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308557/lovemakeup/productos/o1crrhhctarwgcdsrdqn.jpg', 'lovemakeup/productos/o1crrhhctarwgcdsrdqn', 'secundaria'),
(281, 25, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308634/lovemakeup/productos/xuxzqnuzorhnjnp1h7nq.jpg', 'lovemakeup/productos/xuxzqnuzorhnjnp1h7nq', 'principal'),
(282, 25, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308634/lovemakeup/productos/troayubaq21sfr92e1jl.jpg', 'lovemakeup/productos/troayubaq21sfr92e1jl', 'secundaria'),
(283, 25, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308635/lovemakeup/productos/dq1yeaizpw5dcylupynt.jpg', 'lovemakeup/productos/dq1yeaizpw5dcylupynt', 'secundaria'),
(284, 26, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308796/lovemakeup/productos/w2biekufizg3w0wwbepu.jpg', 'lovemakeup/productos/w2biekufizg3w0wwbepu', 'principal'),
(285, 26, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308797/lovemakeup/productos/u7q8qq0nsqvs9m3tcqka.jpg', 'lovemakeup/productos/u7q8qq0nsqvs9m3tcqka', 'secundaria'),
(286, 27, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308835/lovemakeup/productos/udpymkupdsmzapc6mexs.png', 'lovemakeup/productos/udpymkupdsmzapc6mexs', 'principal'),
(287, 28, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308893/lovemakeup/productos/v763dt7xag0apggxir8x.jpg', 'lovemakeup/productos/v763dt7xag0apggxir8x', 'principal'),
(288, 28, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308894/lovemakeup/productos/kxw99kil09twgugqivqz.jpg', 'lovemakeup/productos/kxw99kil09twgugqivqz', 'secundaria'),
(289, 29, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308948/lovemakeup/productos/usuvpe4jfx1c3pubrrjx.jpg', 'lovemakeup/productos/usuvpe4jfx1c3pubrrjx', 'principal'),
(290, 29, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308949/lovemakeup/productos/dwj7msztjiomflypplaa.jpg', 'lovemakeup/productos/dwj7msztjiomflypplaa', 'secundaria'),
(291, 30, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308995/lovemakeup/productos/xosesb9cvyclwtbtrgc7.jpg', 'lovemakeup/productos/xosesb9cvyclwtbtrgc7', 'principal'),
(292, 30, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788308996/lovemakeup/productos/axktze3zt71tt0gtin4m.jpg', 'lovemakeup/productos/axktze3zt71tt0gtin4m', 'secundaria'),
(293, 31, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309245/lovemakeup/productos/zsagbdeof9vtbhcn77rc.jpg', 'lovemakeup/productos/zsagbdeof9vtbhcn77rc', 'principal'),
(294, 32, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309348/lovemakeup/productos/jdbn3ynoefz6wojci8vg.jpg', 'lovemakeup/productos/jdbn3ynoefz6wojci8vg', 'principal'),
(295, 32, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309349/lovemakeup/productos/wupqrr4o2diqpeji8htm.jpg', 'lovemakeup/productos/wupqrr4o2diqpeji8htm', 'secundaria'),
(296, 33, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309384/lovemakeup/productos/sfrcauwjq7i0k1sfkhvo.jpg', 'lovemakeup/productos/sfrcauwjq7i0k1sfkhvo', 'principal'),
(297, 33, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309385/lovemakeup/productos/vyxpgvaj7z1p0e1knlho.jpg', 'lovemakeup/productos/vyxpgvaj7z1p0e1knlho', 'secundaria'),
(298, 34, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309430/lovemakeup/productos/xadubgsdbxe5u4c40e2n.jpg', 'lovemakeup/productos/xadubgsdbxe5u4c40e2n', 'principal'),
(299, 34, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309431/lovemakeup/productos/bhwbky7a8lzkrts0vnhy.jpg', 'lovemakeup/productos/bhwbky7a8lzkrts0vnhy', 'secundaria'),
(300, 35, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309470/lovemakeup/productos/ypbtwrvzvsk3yitlksoy.jpg', 'lovemakeup/productos/ypbtwrvzvsk3yitlksoy', 'principal'),
(301, 35, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309471/lovemakeup/productos/kojofyi2gllrjmrfwoxl.jpg', 'lovemakeup/productos/kojofyi2gllrjmrfwoxl', 'secundaria'),
(302, 36, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309800/lovemakeup/productos/e44trbt7nxrrsyfabw5u.jpg', 'lovemakeup/productos/e44trbt7nxrrsyfabw5u', 'principal'),
(303, 36, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309801/lovemakeup/productos/u5qigmiehdmr3ofinfor.jpg', 'lovemakeup/productos/u5qigmiehdmr3ofinfor', 'secundaria'),
(304, 37, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309875/lovemakeup/productos/lgxl1pvwo278xaejqybr.jpg', 'lovemakeup/productos/lgxl1pvwo278xaejqybr', 'principal'),
(305, 37, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309876/lovemakeup/productos/vw5kbzo5lzh6wbacdez9.jpg', 'lovemakeup/productos/vw5kbzo5lzh6wbacdez9', 'secundaria'),
(306, 37, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309877/lovemakeup/productos/yzaf9v2ozsctcn9ksilq.jpg', 'lovemakeup/productos/yzaf9v2ozsctcn9ksilq', 'secundaria'),
(307, 37, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309877/lovemakeup/productos/zwqydt11dyyqzvwtqfph.jpg', 'lovemakeup/productos/zwqydt11dyyqzvwtqfph', 'secundaria'),
(308, 38, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309922/lovemakeup/productos/kv0rvc2bew9ovmoymjot.png', 'lovemakeup/productos/kv0rvc2bew9ovmoymjot', 'principal'),
(309, 39, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309953/lovemakeup/productos/amd4sroud6qdev7v3mk9.jpg', 'lovemakeup/productos/amd4sroud6qdev7v3mk9', 'principal'),
(310, 39, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309954/lovemakeup/productos/ee6jwfxtg9r1s1sf0v3z.jpg', 'lovemakeup/productos/ee6jwfxtg9r1s1sf0v3z', 'secundaria'),
(311, 40, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788309988/lovemakeup/productos/eojhlgjqnlbw7bggfbhi.png', 'lovemakeup/productos/eojhlgjqnlbw7bggfbhi', 'principal'),
(312, 41, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310087/lovemakeup/productos/mi1maovziajvjpk0sx2j.png', 'lovemakeup/productos/mi1maovziajvjpk0sx2j', 'principal'),
(313, 42, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310108/lovemakeup/productos/mi9lp4ie3bw09hgxvegu.png', 'lovemakeup/productos/mi9lp4ie3bw09hgxvegu', 'principal'),
(314, 43, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310172/lovemakeup/productos/zwarikn6bxk6fyjfoq94.png', 'lovemakeup/productos/zwarikn6bxk6fyjfoq94', 'principal'),
(315, 44, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310207/lovemakeup/productos/lwwfgxy1plfkdugrixeh.jpg', 'lovemakeup/productos/lwwfgxy1plfkdugrixeh', 'principal'),
(316, 44, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310208/lovemakeup/productos/mz8g77739atezutmoexq.jpg', 'lovemakeup/productos/mz8g77739atezutmoexq', 'secundaria'),
(317, 45, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310249/lovemakeup/productos/peh72wmksapn0dlbjbyl.png', 'lovemakeup/productos/peh72wmksapn0dlbjbyl', 'principal'),
(318, 46, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310440/lovemakeup/productos/pjozb1uw373rp1bcvthv.jpg', 'lovemakeup/productos/pjozb1uw373rp1bcvthv', 'principal'),
(319, 46, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310441/lovemakeup/productos/vbmpiiqxq1afqbh578my.jpg', 'lovemakeup/productos/vbmpiiqxq1afqbh578my', 'secundaria'),
(320, 47, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310512/lovemakeup/productos/l6gwqxrx3yfbv42tvydm.jpg', 'lovemakeup/productos/l6gwqxrx3yfbv42tvydm', 'principal'),
(321, 47, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310513/lovemakeup/productos/f0m7xd8vpvmnov0igw2o.jpg', 'lovemakeup/productos/f0m7xd8vpvmnov0igw2o', 'secundaria'),
(322, 48, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310543/lovemakeup/productos/cxyxbplvvdznxx9p1tge.png', 'lovemakeup/productos/cxyxbplvvdznxx9p1tge', 'principal'),
(323, 49, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310581/lovemakeup/productos/cyfijnezchl3lfheepfp.jpg', 'lovemakeup/productos/cyfijnezchl3lfheepfp', 'principal'),
(324, 49, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788310582/lovemakeup/productos/ebxptxbuw6pzzzbx6waq.jpg', 'lovemakeup/productos/ebxptxbuw6pzzzbx6waq', 'secundaria'),
(325, 50, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788311484/lovemakeup/productos/s7m8msfj207gkn0qlsw0.jpg', 'lovemakeup/productos/s7m8msfj207gkn0qlsw0', 'principal'),
(326, 50, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788311485/lovemakeup/productos/ag5vuznxhzej75kjrgbx.jpg', 'lovemakeup/productos/ag5vuznxhzej75kjrgbx', 'secundaria'),
(327, 50, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788311485/lovemakeup/productos/voqxzca4hhhduzwt5izk.jpg', 'lovemakeup/productos/voqxzca4hhhduzwt5izk', 'secundaria'),
(328, 50, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788311486/lovemakeup/productos/ixshgqteh2rsdwcgpus3.jpg', 'lovemakeup/productos/ixshgqteh2rsdwcgpus3', 'secundaria'),
(329, 51, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788311645/lovemakeup/productos/awqonzngcounxksjyiff.jpg', 'lovemakeup/productos/awqonzngcounxksjyiff', 'principal'),
(330, 51, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788311646/lovemakeup/productos/guujswyl1dpmw9jr09iq.jpg', 'lovemakeup/productos/guujswyl1dpmw9jr09iq', 'secundaria'),
(331, 51, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788311647/lovemakeup/productos/eoktq9d811itvaeypabc.jpg', 'lovemakeup/productos/eoktq9d811itvaeypabc', 'secundaria'),
(332, 52, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788311729/lovemakeup/productos/lvas5cjhe267ywltrq9g.png', 'lovemakeup/productos/lvas5cjhe267ywltrq9g', 'principal'),
(336, 53, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788311943/lovemakeup/productos/tb9sath4ykdivnhyadwc.png', 'lovemakeup/productos/tb9sath4ykdivnhyadwc', 'principal'),
(337, 54, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788312046/lovemakeup/productos/jrzntoz8lpim026dswsd.jpg', 'lovemakeup/productos/jrzntoz8lpim026dswsd', 'principal'),
(338, 54, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788312047/lovemakeup/productos/jafwlskuhefkv0g9zzgi.jpg', 'lovemakeup/productos/jafwlskuhefkv0g9zzgi', 'secundaria'),
(339, 55, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788312136/lovemakeup/productos/vfimf6rdserqq1wwhd70.png', 'lovemakeup/productos/vfimf6rdserqq1wwhd70', 'principal'),
(340, 56, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788312307/lovemakeup/productos/gftw82fsrpbzhsaogqar.jpg', 'lovemakeup/productos/gftw82fsrpbzhsaogqar', 'principal'),
(341, 56, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788312308/lovemakeup/productos/qeek7mv4i5tq3nupou6t.jpg', 'lovemakeup/productos/qeek7mv4i5tq3nupou6t', 'secundaria'),
(343, 57, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788312549/lovemakeup/productos/bwymlsdwiymxiagyzinn.png', 'lovemakeup/productos/bwymlsdwiymxiagyzinn', 'principal'),
(344, 58, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788312995/lovemakeup/productos/fficuenyxm3hmbchwkzb.png', 'lovemakeup/productos/fficuenyxm3hmbchwkzb', 'principal'),
(345, 58, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788312996/lovemakeup/productos/naorxn9c1nwhfqdnmkme.png', 'lovemakeup/productos/naorxn9c1nwhfqdnmkme', 'secundaria'),
(346, 59, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788313101/lovemakeup/productos/j7g2ystrinn9o2uyty0j.jpg', 'lovemakeup/productos/j7g2ystrinn9o2uyty0j', 'principal'),
(347, 59, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788313102/lovemakeup/productos/sg9qq5ft3dizjz4g3v3s.jpg', 'lovemakeup/productos/sg9qq5ft3dizjz4g3v3s', 'secundaria'),
(348, 60, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788313339/lovemakeup/productos/qyjgkn9qeibnbfxuybal.jpg', 'lovemakeup/productos/qyjgkn9qeibnbfxuybal', 'principal'),
(349, 60, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788313340/lovemakeup/productos/de3xoq5gtjhhonlnevdv.jpg', 'lovemakeup/productos/de3xoq5gtjhhonlnevdv', 'secundaria'),
(350, 61, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788313505/lovemakeup/productos/ahiorlohvvowwuyzyve7.jpg', 'lovemakeup/productos/ahiorlohvvowwuyzyve7', 'principal'),
(351, 61, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788313505/lovemakeup/productos/yeujvdgci9dtguy9ymw6.jpg', 'lovemakeup/productos/yeujvdgci9dtguy9ymw6', 'secundaria'),
(352, 61, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1788313506/lovemakeup/productos/ce5ycthqgoxl3livkqhx.jpg', 'lovemakeup/productos/ce5ycthqgoxl3livkqhx', 'secundaria'),
(353, 62, 'https://res.cloudinary.com/xtyekdoi/image/upload/q_auto,f_auto/v1792032294/lovemakeup/productos/jpttq9pp24spporw17tf.png', 'lovemakeup/productos/jpttq9pp24spporw17tf', 'principal');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `id_proveedor` int(11) NOT NULL,
  `tipo_documento` varchar(10) DEFAULT NULL,
  `numero_documento` varchar(20) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `estatus` int(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`id_proveedor`, `tipo_documento`, `numero_documento`, `nombre`, `correo`, `telefono`, `direccion`, `estatus`) VALUES
(1, 'J', '900800700', 'Inveriones casa de maquijalle', 'inversionescasa@hotmail.com', '02518862233', 'av lara', 1),
(2, 'J', '301234567', 'Inversiones cosméticas centro', 'contacto@glamourbelleza.com', '0414-5551234', 'Centro Comercial Las Trinitarias Local 12 Cabudare', 1),
(3, 'J', '298765432', 'Suministros estéticos occide', 'info@suministrosoccidente.com', '0251-2334455', 'Carrera 19 con Calle 25 Edificio Centro Barquisimeto', 1),
(4, 'J', '312233445', 'Importaciones cosméticas', 'pedidos@variedadescosmeticas.com', '0412-7778899', 'Avenida Intercomunal Sector La Mora Cabudare', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `referencia_pago`
--

CREATE TABLE `referencia_pago` (
  `id_referencia` int(11) NOT NULL,
  `id_pago` int(11) DEFAULT NULL,
  `banco_emisor` varchar(50) DEFAULT NULL,
  `banco_receptor` varchar(50) DEFAULT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `telefono_emisor` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `referencia_pago`
--

INSERT INTO `referencia_pago` (`id_referencia`, `id_pago`, `banco_emisor`, `banco_receptor`, `referencia`, `telefono_emisor`) VALUES
(1, 1, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '123123', '04246564654'),
(2, 2, NULL, NULL, '555455', NULL),
(3, 5, '0104-Banco Venezolano De Credito', '0102-Banco De Venezuela', '4569', '04245071950'),
(4, 6, NULL, NULL, '2587', NULL),
(5, 7, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '123123', '04246564654'),
(6, 8, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '123123', '04246564654'),
(7, 9, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '69944', '04149739941'),
(8, 10, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '9988', '04161228705'),
(9, 11, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '77144', '04149739941'),
(10, 12, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '77544', '04245604455'),
(11, 13, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '04544', '04245390678'),
(12, 14, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '1231', '04245797918'),
(13, 15, NULL, NULL, '542355', NULL),
(14, 16, NULL, NULL, '112212', NULL),
(15, 18, '0114-Bancaribe', '0102-Banco De Venezuela', '222222', '04245165987'),
(16, 20, '0171-Banco Activo', '0105-Banco Mercantil', '171717', '04241231414'),
(17, 21, NULL, NULL, NULL, NULL),
(18, 22, NULL, NULL, NULL, NULL),
(19, 23, NULL, NULL, NULL, NULL),
(20, 24, NULL, NULL, NULL, NULL),
(21, 25, NULL, NULL, NULL, NULL),
(22, 26, NULL, NULL, NULL, NULL),
(23, 27, NULL, NULL, NULL, NULL),
(24, 28, NULL, NULL, NULL, NULL),
(25, 29, NULL, NULL, NULL, NULL),
(26, 30, NULL, NULL, NULL, NULL),
(27, 31, NULL, NULL, NULL, NULL),
(28, 32, NULL, NULL, NULL, NULL),
(29, 33, NULL, NULL, NULL, NULL),
(30, 34, NULL, NULL, NULL, NULL),
(31, 35, NULL, NULL, NULL, NULL),
(32, 36, NULL, NULL, NULL, NULL),
(33, 37, NULL, NULL, NULL, NULL),
(34, 38, NULL, NULL, NULL, NULL),
(35, 39, NULL, NULL, NULL, NULL),
(36, 40, NULL, NULL, NULL, NULL),
(37, 41, NULL, NULL, NULL, NULL),
(38, 42, NULL, NULL, NULL, NULL),
(39, 43, NULL, NULL, NULL, NULL),
(40, 44, NULL, NULL, NULL, NULL),
(41, 45, NULL, NULL, NULL, NULL),
(42, 46, NULL, NULL, NULL, NULL),
(43, 47, NULL, NULL, NULL, NULL),
(44, 48, NULL, NULL, NULL, NULL),
(45, 49, NULL, NULL, '555555', '04145598767'),
(46, 50, NULL, NULL, '545363', NULL),
(47, 52, NULL, NULL, '345555', NULL),
(48, 53, NULL, NULL, '554376', NULL),
(49, 54, NULL, NULL, '342266', NULL),
(50, 55, NULL, NULL, '345666', NULL),
(51, 56, 'Venezuela', '0105-Banco Mercantil', '1234', '04245196914'),
(52, 57, 'Venezuela', '0105-Banco Mercantil', '12345', '04245196914'),
(53, 58, '0102-Banco De Venezuela', '0105-Banco Mercantil', '12345', '04245196914'),
(54, 59, '0171-Banco Activo', '0102-Banco De Venezuela', '12343646', '04240566797'),
(55, 60, '0138-Banco Plaza', '0102-Banco De Venezuela', '924247', '04245390678'),
(56, 61, '0157-Delsur Banco Universal', '0105-Banco Mercantil', '6454688', '04149739941'),
(57, 62, '0102-Banco De Venezuela', '0105-Banco Mercantil', '64573794', '0426243903'),
(58, 63, '0102-Banco De Venezuela', '0105-Banco Mercantil', '1234', '04245196914'),
(59, 64, '0102-Banco De Venezuela', '0105-Banco Mercantil', '1235', '04245196914'),
(60, 65, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '1236', '04245196914'),
(61, 66, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '4321', '04245196914'),
(62, 67, '0102-Banco De Venezuela', '0105-Banco Mercantil', '65432', '04245196914'),
(63, 68, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '1231', '04245797918'),
(64, 69, '0104-Banco Venezolano De Credito', '0102-Banco De Venezuela', '63456', '04149739941'),
(65, 70, '0146-Bangente', '0102-Banco De Venezuela', '0', '0'),
(66, 71, '0108-BBVA Provincial', '0102-Banco De Venezuela', '565366', '04149739941'),
(67, 73, NULL, NULL, '456462', NULL),
(68, 74, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '0654', '04244846764'),
(69, 75, NULL, NULL, '66555', NULL),
(70, 76, '0115-Banco Exterior', '0102-Banco De Venezuela', '65599', '04149739941'),
(71, 77, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '77144', '04245390678'),
(72, 78, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '123123', '04246564654'),
(73, 79, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '456455', '04149736614'),
(74, 80, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '77544', '04245604455'),
(75, 81, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '564576', '04149739941'),
(76, 82, '0172-Bancamiga Banco Universal,C.A', '0105-Banco Mercantil', '94657648', '0546467'),
(77, 83, '0138-Banco Plaza', '0102-Banco De Venezuela', '77144', '04246564654'),
(78, 84, '0138-Banco Plaza', '0105-Banco Mercantil', '123123', '04245390678'),
(79, 85, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '77144', '04245390678'),
(80, 86, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '9988', '04246564654'),
(81, 87, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '123123', '04245390678'),
(82, 88, '0134-Banesco', '0105-Banco Mercantil', '123123', '04246564654'),
(83, 89, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '9988', '04245390678'),
(84, 90, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '123123', '04245390678'),
(85, 91, '0138-Banco Plaza', '0102-Banco De Venezuela', '77144', '04246564654'),
(86, 92, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '77144', '04246564654'),
(87, 93, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '995584', '04120670618'),
(88, 94, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '025386', '04146555432'),
(89, 95, '0134-Banesco', '0105-Banco Mercantil', '123123', '04245390678'),
(90, 96, '0108-BBVA Provincial', '0102-Banco De Venezuela', '9988', '04245649666'),
(91, 97, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '123123', '04245390678'),
(92, 98, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '9988', '04246564654'),
(93, 99, NULL, NULL, '45612', NULL),
(94, 100, NULL, NULL, '99654', NULL),
(95, 101, NULL, NULL, '12444', NULL),
(96, 102, NULL, NULL, '312312', NULL),
(97, 105, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '77144', '04246564654'),
(98, 106, NULL, NULL, '66588', NULL),
(99, 107, NULL, NULL, '56655', NULL),
(100, 108, '0172-Bancamiga Banco Universal,C.A', '0105-Banco Mercantil', '65487', '04120670618'),
(101, 110, NULL, NULL, '122222', NULL),
(102, 111, NULL, NULL, '66954', NULL),
(103, 116, '0105-Banco Mercantil', '0105-Banco Mercantil', '656498', '04140105564'),
(104, 118, NULL, NULL, '987794', NULL),
(105, 119, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '555555', '04245196914'),
(106, 120, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '5652', '04245196914'),
(107, 121, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '5555', '04245196917'),
(108, 122, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '2523', '04245795818'),
(109, 123, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '23131', '04149739941'),
(110, 124, '0105-Banco Mercantil', '0105-Banco Mercantil', '986768', '041497399416666'),
(111, 125, '0172-Bancamiga Banco Universal,C.A', '0105-Banco Mercantil', '555555', '04165864555'),
(112, 126, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '25386', '04165864555'),
(113, 127, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '46800', '04165763798'),
(114, 128, '0172-Bancamiga Banco Universal,C.A', '0105-Banco Mercantil', '041497', '042563799737'),
(115, 129, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '2525', '04245196914'),
(116, 130, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '2525', '04245196914'),
(117, 131, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '2525', '04245196914'),
(118, 132, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '2525', '04245196914'),
(119, 133, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '2525', '04245196914'),
(120, 134, '0108-BBVA Provincial', '0105-Banco Mercantil', '041497', '04149739941'),
(121, 135, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '234888', '04145689088'),
(122, 136, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '123645', '04245127864'),
(123, 137, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '2325', '04245196914'),
(124, 138, '0172-Bancamiga Banco Universal,C.A', '0105-Banco Mercantil', '325864', '04149739941'),
(125, 139, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '664649', '04149739941'),
(126, 140, '0102-Banco De Venezuela', '0105-Banco Mercantil', '045465', '04149739941'),
(127, 141, '0156-100% Banco ', '0102-Banco De Venezuela', '2585', '04245952471'),
(128, 142, '0114-Bancaribe', '0105-Banco Mercantil', '22156', '04246978487'),
(129, 143, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '2222', '04245071950'),
(130, 144, '0114-Bancaribe', '0102-Banco De Venezuela', '04444', '04149739941'),
(131, 145, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '0998', '04245196914'),
(132, 146, '0134-Banesco', '0105-Banco Mercantil', '84855', '04245657378'),
(133, 147, '0105-Banco Mercantil', '0102-Banco De Venezuela', '66464', '04246797679'),
(134, 148, '0146-Bangente', '0102-Banco De Venezuela', '978767', '04149739941'),
(135, 149, '0172-Bancamiga Banco Universal,C.A', '0102-Banco De Venezuela', '042450', '04245071950'),
(136, 150, '0171-Banco Activo', '0105-Banco Mercantil', '646446', '04245071950'),
(137, 151, '0171-Banco Activo', '0105-Banco Mercantil', '242424', '04245071950'),
(138, 152, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '645648', '04149739941'),
(139, 153, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '65469', '04149739941'),
(140, 154, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '666548', '04149739941'),
(141, 155, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '356881', '04149739941'),
(142, 156, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '556987', '04149739941'),
(143, 157, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '565412', '04149739941'),
(144, 158, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '325664', '04149739941'),
(145, 159, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '635466', '04149739941'),
(146, 160, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '364555', '04149739941'),
(147, 161, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '236588', '04149739941'),
(148, 162, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '365675', '04149769941'),
(149, 163, '0102-Banco De Venezuela', '0102-Banco De Venezuela', '658965', '04149739941'),
(150, 164, '0102-Banco De Venezuela', '0105-Banco Mercantil', '765272', '04245196914'),
(151, 166, '0168-Bancrecer', '0102-Banco De Venezuela', '666222', '04245071950');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reserva`
--

CREATE TABLE `reserva` (
  `id_reserva` int(11) NOT NULL,
  `id_pedido` int(11) DEFAULT NULL,
  `fecha_retiro` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `reserva`
--

INSERT INTO `reserva` (`id_reserva`, `id_pedido`, `fecha_retiro`) VALUES
(1, 8, NULL),
(2, 11, NULL),
(3, 77, NULL),
(4, 83, NULL),
(5, 85, NULL),
(6, 90, NULL),
(7, 94, NULL),
(8, 125, NULL),
(9, 127, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tasa_dolar`
--

CREATE TABLE `tasa_dolar` (
  `fecha` date NOT NULL,
  `tasa_bs` decimal(10,2) DEFAULT NULL,
  `fuente` varchar(100) DEFAULT NULL,
  `estatus` int(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `tasa_dolar`
--

INSERT INTO `tasa_dolar` (`fecha`, `tasa_bs`, `fuente`, `estatus`) VALUES
('2026-04-18', 480.26, 'Automatico', 1),
('2026-04-20', 481.22, 'Automatico', 1),
('2026-04-21', 481.70, 'Automatico', 1),
('2026-04-22', 482.76, 'Automatico', 1),
('2026-04-26', 483.87, 'Automatico', 1),
('2026-04-27', 484.74, 'Automatico', 1),
('2026-04-29', 486.20, 'Automatico', 1),
('2026-05-08', 499.86, 'Automatico', 1),
('2026-05-12', 504.91, 'Automatico', 1),
('2026-05-17', 515.18, 'Automatico', 1),
('2026-05-20', 520.91, 'Automatico', 1),
('2026-05-21', 523.67, 'Automatico', 1),
('2026-05-22', 526.87, 'Automatico', 1),
('2026-05-24', 526.87, 'Automatico', 1),
('2026-05-25', 530.50, 'Automatico', 1),
('2026-05-26', 535.39, 'Automatico', 1),
('2026-05-27', 540.04, 'Automatico', 1),
('2026-05-28', 544.58, 'Via Internet', 1),
('2026-05-31', 549.37, 'Automatico', 1),
('2026-06-01', 554.43, 'Automatico', 1),
('2026-06-02', 557.97, 'Automatico', 1),
('2026-06-04', 560.38, 'Automatico', 1),
('2026-06-05', 560.38, 'Automatico', 1),
('2026-06-06', 563.29, 'Automatico', 1),
('2026-06-07', 563.29, 'Automatico', 1),
('2026-06-14', 582.69, 'Automatico', 1),
('2026-06-15', 587.41, 'Automatico', 1),
('2026-06-18', 563.29, 'Automatico', 1),
('2026-06-19', 607.39, 'Via Internet', 1),
('2026-06-21', 602.33, 'Automatico', 1),
('2026-06-22', 612.43, 'Automatico', 1),
('2026-06-24', 617.64, 'Automatico', 1),
('2026-06-25', 621.53, 'Automatico', 1),
('2026-06-26', 622.21, 'Automatico', 1),
('2026-06-27', 622.21, 'Automatico', 1),
('2026-06-30', 607.39, 'Automatico', 1),
('2026-07-02', 607.39, 'Automatico', 1),
('2026-07-05', 652.97, 'Automatico', 1),
('2026-07-06', 652.97, 'Automatico', 1),
('2026-07-07', 674.93, 'Automatico', 1),
('2026-07-09', 700.22, 'Automatico', 1),
('2026-07-10', 709.69, 'Automatico', 1),
('2026-07-19', 732.48, 'Automatico', 1),
('2026-07-21', 737.23, 'Automatico', 1),
('2026-07-28', 742.81, 'Automatico', 1),
('2026-07-31', 746.63, 'Automatico', 1),
('2026-08-02', 746.63, 'Automatico', 1),
('2026-08-12', 764.35, 'Automatico', 1),
('2026-08-13', 764.35, 'Automatico', 1),
('2026-08-14', 771.07, 'Automatico', 1),
('2026-08-15', 771.07, 'Automatico', 1),
('2026-08-17', 772.54, 'Automatico', 1),
('2026-08-19', 775.34, 'Automatico', 1),
('2026-08-20', 777.42, 'Automatico', 1),
('2026-08-21', 779.95, 'Automatico', 1),
('2026-08-22', 779.95, 'Automatico', 1),
('2026-08-23', 779.95, 'Automatico', 1),
('2026-08-24', 784.66, 'Automatico', 1),
('2026-08-25', 785.07, 'Automatico', 1),
('2026-08-26', 787.52, 'Automatico', 1),
('2026-08-27', 791.32, 'Automatico', 1),
('2026-08-28', 791.32, 'Automatico', 1),
('2026-08-29', 791.67, 'Automatico', 1),
('2026-08-30', 791.67, 'Automatico', 1),
('2026-08-31', 794.99, 'Automatico', 1),
('2026-09-01', 798.33, 'Automatico', 1),
('2026-09-02', 801.18, 'Automatico', 1),
('2026-09-03', 804.81, 'Automatico', 1),
('2026-09-04', 807.39, 'Automatico', 1),
('2026-09-08', 814.69, 'Automatico', 1),
('2026-09-09', 820.10, 'Automatico', 1),
('2026-09-10', 827.74, 'Automatico', 1),
('2026-09-13', 832.49, 'Automatico', 1),
('2026-09-15', 842.21, 'Automatico', 1),
('2026-09-23', 853.50, 'Automatico', 1),
('2026-10-03', 866.56, 'Automatico', 1),
('2026-10-09', 875.65, 'Automatico', 1),
('2026-10-10', 875.65, 'Automatico', 1),
('2026-10-11', 875.65, 'Automatico', 1),
('2026-10-12', 875.65, 'Automatico', 1),
('2026-10-13', 876.80, 'Automatico', 1),
('2026-10-14', 877.90, 'Automatico', 1),
('2026-10-15', 879.12, 'Automatico', 1),
('2026-10-16', 879.12, 'Automatico', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

CREATE TABLE `venta` (
  `id_venta` int(11) NOT NULL,
  `id_pedido` int(11) DEFAULT NULL,
  `fecha_confirmacion` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `venta`
--

INSERT INTO `venta` (`id_venta`, `id_pedido`, `fecha_confirmacion`) VALUES
(1, 2, '2026-04-21 23:05:51'),
(2, 3, '2026-04-22 17:38:03'),
(3, 4, '2026-04-22 17:41:40'),
(4, 5, '2026-04-22 17:42:31'),
(5, 6, '2026-04-22 17:43:54'),
(6, 15, '2026-06-05 04:34:33'),
(7, 16, '2026-07-06 16:42:15'),
(8, 18, '2026-07-06 19:28:03'),
(9, 49, '2026-07-21 16:18:48'),
(10, 50, '2026-07-21 16:19:36'),
(11, 51, '2026-07-21 16:21:15'),
(12, 52, '2026-07-21 18:29:15'),
(13, 53, '2026-07-21 18:30:56'),
(14, 54, '2026-07-21 18:33:24'),
(15, 71, '2026-08-20 20:39:30'),
(16, 72, '2026-08-20 20:40:14'),
(17, 73, '2026-08-20 20:43:22'),
(18, 74, '2026-08-20 20:44:06'),
(19, 98, '2026-08-28 03:30:58'),
(20, 99, '2026-08-28 03:31:40'),
(21, 100, '2026-08-28 03:32:19'),
(22, 101, '2026-08-28 03:34:33'),
(23, 102, '2026-08-28 03:35:33'),
(24, 104, '2026-08-30 03:55:17'),
(25, 105, '2026-08-30 03:55:57'),
(26, 106, '2026-08-30 03:57:42'),
(27, 107, '2026-08-30 03:58:26'),
(28, 108, '2026-08-31 02:17:59'),
(29, 109, '2026-08-31 02:20:41'),
(30, 110, '2026-08-31 02:21:32'),
(31, 111, '2026-08-31 02:23:06'),
(32, 112, '2026-08-31 02:23:43'),
(33, 159, '2026-10-15 22:51:54'),
(34, 160, '2026-10-16 02:29:57'),
(35, 161, '2026-10-16 03:39:04');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `compra`
--
ALTER TABLE `compra`
  ADD PRIMARY KEY (`id_compra`),
  ADD KEY `id_proveedor` (`id_proveedor`);

--
-- Indices de la tabla `compra_detalles`
--
ALTER TABLE `compra_detalles`
  ADD PRIMARY KEY (`id_detalle_compra`),
  ADD KEY `id_compra` (`id_compra`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `comprobante_pago`
--
ALTER TABLE `comprobante_pago`
  ADD PRIMARY KEY (`id_comprobante`),
  ADD KEY `id_pago` (`id_pago`);

--
-- Indices de la tabla `delivery`
--
ALTER TABLE `delivery`
  ADD PRIMARY KEY (`id_delivery`);

--
-- Indices de la tabla `detalle_pago`
--
ALTER TABLE `detalle_pago`
  ADD PRIMARY KEY (`id_pago`),
  ADD KEY `id_metodopago` (`id_metodopago`);

--
-- Indices de la tabla `direccion`
--
ALTER TABLE `direccion`
  ADD PRIMARY KEY (`id_direccion`),
  ADD KEY `id_metodoentrega` (`id_metodoentrega`),
  ADD KEY `id_delivery` (`id_delivery`),
  ADD KEY `cedula` (`cedula`);

--
-- Indices de la tabla `lista_deseo`
--
ALTER TABLE `lista_deseo`
  ADD PRIMARY KEY (`id_lista`),
  ADD KEY `id_producto` (`id_producto`),
  ADD KEY `cedula` (`cedula`);

--
-- Indices de la tabla `marca`
--
ALTER TABLE `marca`
  ADD PRIMARY KEY (`id_marca`);

--
-- Indices de la tabla `metodo_entrega`
--
ALTER TABLE `metodo_entrega`
  ADD PRIMARY KEY (`id_entrega`);

--
-- Indices de la tabla `metodo_pago`
--
ALTER TABLE `metodo_pago`
  ADD PRIMARY KEY (`id_metodopago`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id_notificacion`),
  ADD KEY `id_pedido` (`id_pedido`);

--
-- Indices de la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `id_direccion` (`id_direccion`),
  ADD KEY `id_pago` (`id_pago`),
  ADD KEY `cedula` (`cedula`);

--
-- Indices de la tabla `pedido_detalles`
--
ALTER TABLE `pedido_detalles`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `id_pedido` (`id_pedido`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `id_categoria` (`id_categoria`),
  ADD KEY `id_marca` (`id_marca`),
  ADD KEY `nombre` (`nombre`),
  ADD KEY `stock_disponible` (`stock_disponible`);

--
-- Indices de la tabla `producto_imagen`
--
ALTER TABLE `producto_imagen`
  ADD PRIMARY KEY (`id_imagen`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`id_proveedor`),
  ADD KEY `numero_documento` (`numero_documento`);

--
-- Indices de la tabla `referencia_pago`
--
ALTER TABLE `referencia_pago`
  ADD PRIMARY KEY (`id_referencia`),
  ADD KEY `id_pago` (`id_pago`);

--
-- Indices de la tabla `reserva`
--
ALTER TABLE `reserva`
  ADD PRIMARY KEY (`id_reserva`),
  ADD KEY `id_pedido` (`id_pedido`);

--
-- Indices de la tabla `tasa_dolar`
--
ALTER TABLE `tasa_dolar`
  ADD PRIMARY KEY (`fecha`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`id_venta`),
  ADD KEY `id_pedido` (`id_pedido`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `compra`
--
ALTER TABLE `compra`
  MODIFY `id_compra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT de la tabla `compra_detalles`
--
ALTER TABLE `compra_detalles`
  MODIFY `id_detalle_compra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT de la tabla `comprobante_pago`
--
ALTER TABLE `comprobante_pago`
  MODIFY `id_comprobante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT de la tabla `delivery`
--
ALTER TABLE `delivery`
  MODIFY `id_delivery` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `detalle_pago`
--
ALTER TABLE `detalle_pago`
  MODIFY `id_pago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=168;

--
-- AUTO_INCREMENT de la tabla `direccion`
--
ALTER TABLE `direccion`
  MODIFY `id_direccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=118;

--
-- AUTO_INCREMENT de la tabla `lista_deseo`
--
ALTER TABLE `lista_deseo`
  MODIFY `id_lista` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT de la tabla `marca`
--
ALTER TABLE `marca`
  MODIFY `id_marca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `metodo_entrega`
--
ALTER TABLE `metodo_entrega`
  MODIFY `id_entrega` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `metodo_pago`
--
ALTER TABLE `metodo_pago`
  MODIFY `id_metodopago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id_notificacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT de la tabla `pedido`
--
ALTER TABLE `pedido`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=162;

--
-- AUTO_INCREMENT de la tabla `pedido_detalles`
--
ALTER TABLE `pedido_detalles`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT de la tabla `producto_imagen`
--
ALTER TABLE `producto_imagen`
  MODIFY `id_imagen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=354;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `referencia_pago`
--
ALTER TABLE `referencia_pago`
  MODIFY `id_referencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT de la tabla `reserva`
--
ALTER TABLE `reserva`
  MODIFY `id_reserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `venta`
--
ALTER TABLE `venta`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `compra`
--
ALTER TABLE `compra`
  ADD CONSTRAINT `compra_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id_proveedor`);

--
-- Filtros para la tabla `compra_detalles`
--
ALTER TABLE `compra_detalles`
  ADD CONSTRAINT `compra_detalles_ibfk_1` FOREIGN KEY (`id_compra`) REFERENCES `compra` (`id_compra`),
  ADD CONSTRAINT `compra_detalles_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`);

--
-- Filtros para la tabla `comprobante_pago`
--
ALTER TABLE `comprobante_pago`
  ADD CONSTRAINT `comprobante_pago_ibfk_1` FOREIGN KEY (`id_pago`) REFERENCES `detalle_pago` (`id_pago`);

--
-- Filtros para la tabla `detalle_pago`
--
ALTER TABLE `detalle_pago`
  ADD CONSTRAINT `detalle_pago_ibfk_1` FOREIGN KEY (`id_metodopago`) REFERENCES `metodo_pago` (`id_metodopago`);

--
-- Filtros para la tabla `direccion`
--
ALTER TABLE `direccion`
  ADD CONSTRAINT `direccion_ibfk_1` FOREIGN KEY (`id_metodoentrega`) REFERENCES `metodo_entrega` (`id_entrega`),
  ADD CONSTRAINT `direccion_ibfk_2` FOREIGN KEY (`id_delivery`) REFERENCES `delivery` (`id_delivery`);

--
-- Filtros para la tabla `lista_deseo`
--
ALTER TABLE `lista_deseo`
  ADD CONSTRAINT `lista_deseo_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`);

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`);

--
-- Filtros para la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`id_direccion`) REFERENCES `direccion` (`id_direccion`),
  ADD CONSTRAINT `pedido_ibfk_2` FOREIGN KEY (`id_pago`) REFERENCES `detalle_pago` (`id_pago`);

--
-- Filtros para la tabla `pedido_detalles`
--
ALTER TABLE `pedido_detalles`
  ADD CONSTRAINT `pedido_detalles_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`),
  ADD CONSTRAINT `pedido_detalles_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`);

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`),
  ADD CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`id_marca`) REFERENCES `marca` (`id_marca`);

--
-- Filtros para la tabla `producto_imagen`
--
ALTER TABLE `producto_imagen`
  ADD CONSTRAINT `producto_imagen_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`);

--
-- Filtros para la tabla `referencia_pago`
--
ALTER TABLE `referencia_pago`
  ADD CONSTRAINT `referencia_pago_ibfk_1` FOREIGN KEY (`id_pago`) REFERENCES `detalle_pago` (`id_pago`);

--
-- Filtros para la tabla `reserva`
--
ALTER TABLE `reserva`
  ADD CONSTRAINT `reserva_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`);

--
-- Filtros para la tabla `venta`
--
ALTER TABLE `venta`
  ADD CONSTRAINT `venta_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
