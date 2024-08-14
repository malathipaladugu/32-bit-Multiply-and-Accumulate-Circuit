library ieee;
use ieee.std_logic_1164.all;
use work.ANDgate_23m1200_package.all;
use work.XORgate_23m1200_package.all;
use work.ABCgate_23m1200_package.all;
use work.Cin_map_G_23m1200_package.all;
use work.FA_package.all;
use work.HA_package.all;

entity MAC_Dadda_23m1200_2 is
  port ( A,B: in std_logic_Vector( 15 downto 0);
         C : in std_logic_Vector(31 downto 0);
			MAC_out : out std_logic_Vector(31 downto 0);
			MAC_Carry_out : out std_logic;
			MAC_A, MAC_B :out std_logic_vector(31 downto 0));
end entity;

architecture ar1 of MAC_Dadda_23m1200_2 is
  type t_array16X16 is array(0 to 15, 0 to 15) of std_logic;
  signal P_AB : t_array16X16;
  signal FA_sum, FA_Co : std_logic_vector(0 to 223); -- total of 224 full adders are required
  signal HA_sum, HA_Co : std_logic_vector(0 to 15); --  total of 16 Half adders are required
  signal MAC_TA, MAC_TB : std_logic_vector(31 downto 0); -- final reduced two 32bit vectros for addition
  signal BK_Cinrl : std_logic_vector(32 downto 1); -- Brent Kaung adder intermideate steps
begin
  LP_ABi : for i in 0 to 15 generate
    LP_ABj : for j in 0 to 15 generate
				   i_AB : ANDgate_23m1200 port map(A(j), B(i), P_AB(i,j)); -- ((a0b0, a1b0 ...a15b0);(a0b1,a1b1...a15b1);....(a0b15,a1b15...a15b15))
				 end generate LP_ABj; 
           end generate LP_ABi;
			  
--- 1st layer FA's and HA's
  HA1 : HA port map(C(12),P_AB(0,12),HA_sum(0),HA_Co(0));
  HA2 : HA port map(P_AB(2,11),P_AB(3,10),HA_sum(1),HA_Co(1));
  HA3 : HA port map(P_AB(5,9),P_AB(6,8),HA_sum(2),HA_Co(2));
  HA4 : HA port map(P_AB(8,7),P_AB(9,6),HA_sum(3),HA_Co(3));
  HA5 : HA port map(P_AB(9,7),P_AB(10,6),HA_sum(4),HA_Co(4));  
  
  FA1 : FA port map(C(13),P_AB(0,13),P_AB(1,12),FA_sum(0),FA_Co(0));
  FA2 : FA port map(C(14),P_AB(0,14),P_AB(1,13),FA_sum(1),FA_Co(1));
  FA3 : FA port map(C(15),P_AB(0,15),P_AB(1,14),FA_sum(2),FA_Co(2));
  FA4 : FA port map(C(16),P_AB(1,15),P_AB(2,14),FA_sum(3),FA_Co(3));
  FA5 : FA port map(C(17),P_AB(2,15),P_AB(3,14),FA_sum(4),FA_Co(4));
  FA6 : FA port map(C(18),P_AB(3,15),P_AB(4,14),FA_sum(5),FA_Co(5));
  FA7 : FA port map(C(19),P_AB(4,15),P_AB(5,14),FA_sum(6),FA_Co(6));
  FA8 : FA port map(P_AB(2,12),P_AB(3,11),P_AB(4,10),FA_sum(7),FA_Co(7));
  FA9 : FA port map(P_AB(2,13),P_AB(3,12),P_AB(4,11),FA_sum(8),FA_Co(8));
  FA10 : FA port map(P_AB(3,13),P_AB(4,12),P_AB(5,11),FA_sum(9),FA_Co(9));
  FA11 : FA port map(P_AB(4,13),P_AB(5,12),P_AB(6,11),FA_sum(10),FA_Co(10));
  FA12 : FA port map(P_AB(5,13),P_AB(6,12),P_AB(7,11),FA_sum(11),FA_Co(11));
  FA13 : FA port map(P_AB(5,10),P_AB(6,9),P_AB(7,8),FA_sum(12),FA_Co(12));
  FA14 : FA port map(P_AB(6,10),P_AB(7,9),P_AB(8,8),FA_sum(13),FA_Co(13));
  FA15 : FA port map(P_AB(7,10),P_AB(8,9),P_AB(9,8),FA_sum(14),FA_Co(14));

-- 2nd layer FA's and HA's
  HA6 : HA port map(C(8),P_AB(0,8),HA_sum(5),HA_Co(5));
  HA7 : HA port map(P_AB(2,7),P_AB(3,6),HA_sum(6),HA_Co(6));
  HA8 : HA port map(P_AB(5,5),P_AB(6,4),HA_sum(7),HA_Co(7));
  HA9 : HA port map(P_AB(8,3),P_AB(9,2),HA_sum(8),HA_Co(8));
  
  FA16 : FA port map(C(9),P_AB(0,9),P_AB(1,8),FA_sum(15),FA_Co(15));
  FA17 : FA port map(C(10),P_AB(0,10),P_AB(1,9),FA_sum(16),FA_Co(16));
  FA18 : FA port map(C(11),P_AB(0,11),P_AB(1,10),FA_sum(17),FA_Co(17));
  FA19 : FA port map(HA_sum(0),P_AB(1,11),P_AB(2,10),FA_sum(18),FA_Co(18));
  FA20 : FA port map(FA_sum(0),HA_Co(0),HA_sum(1),FA_sum(19),FA_Co(19));
  FA21 : FA port map(FA_sum(1),FA_Co(0),FA_sum(7),FA_sum(20),FA_Co(20));
  FA22 : FA port map(FA_sum(2),FA_Co(1),FA_sum(8),FA_sum(21),FA_Co(21));
  FA23 : FA port map(FA_sum(3),FA_Co(2),FA_sum(9),FA_sum(22),FA_Co(22));
  FA24 : FA port map(FA_sum(4),FA_Co(3),FA_sum(10),FA_sum(23),FA_Co(23));
  FA25 : FA port map(FA_sum(5),FA_Co(4),FA_sum(11),FA_sum(24),FA_Co(24));
  FA26 : FA port map(FA_sum(6),FA_Co(5),P_AB(6,13),FA_sum(25),FA_Co(25)); -- check this if any error is there
  FA27 : FA port map(C(20),FA_Co(6),P_AB(5,15),FA_sum(26),FA_Co(26));
  FA28 : FA port map(C(21),P_AB(6,15),P_AB(7,14),FA_sum(27),FA_Co(27));
  FA29 : FA port map(C(22),P_AB(7,15),P_AB(8,14),FA_sum(28),FA_Co(28));
  FA30 : FA port map(C(23),P_AB(8,15),P_AB(9,14),FA_sum(29),FA_Co(29));
  FA31 : FA port map(P_AB(2,8),P_AB(3,7),P_AB(4,6),FA_sum(30),FA_Co(30));
  FA32 : FA port map(P_AB(2,9),P_AB(3,8),P_AB(4,7),FA_sum(31),FA_Co(31));
  FA33 : FA port map(P_AB(3,9),P_AB(4,8),P_AB(5,7),FA_sum(32),FA_Co(32));
  FA34 : FA port map(P_AB(4,9),P_AB(5,8),P_AB(6,7),FA_sum(33),FA_Co(33));
  FA35 : FA port map(HA_Co(1),HA_sum(2),P_AB(7,7),FA_sum(34),FA_Co(34));
  FA36 : FA port map(FA_Co(7),FA_sum(12),HA_Co(2),FA_sum(35),FA_Co(35));
  FA37 : FA port map(FA_Co(8),FA_sum(13),FA_Co(12),FA_sum(36),FA_Co(36));
  FA38 : FA port map(FA_Co(9),FA_sum(14),FA_Co(13),FA_sum(37),FA_Co(37));
  FA39 : FA port map(FA_Co(10),P_AB(8,10),FA_Co(14),FA_sum(38),FA_Co(38));
  FA40 : FA port map(FA_Co(11),P_AB(7,12),P_AB(8,11),FA_sum(39),FA_Co(39));
  FA41 : FA port map(P_AB(6,14),P_AB(7,13),P_AB(8,12),FA_sum(40),FA_Co(40));
  FA42 : FA port map(P_AB(8,13),P_AB(9,12),P_AB(10,11),FA_sum(41),FA_Co(41));
  FA43 : FA port map(P_AB(9,13),P_AB(10,12),P_AB(11,11),FA_sum(42),FA_Co(42));
  FA44 : FA port map(P_AB(5,6),P_AB(6,5),P_AB(7,4),FA_sum(43),FA_Co(43));
  FA45 : FA port map(P_AB(6,6),P_AB(7,5),P_AB(8,4),FA_sum(44),FA_Co(44));
  FA46 : FA port map(P_AB(7,6),P_AB(8,5),P_AB(9,4),FA_sum(45),FA_Co(45));
  FA47 : FA port map(P_AB(8,6),P_AB(9,5),P_AB(10,4),FA_sum(46),FA_Co(46));
  FA48 : FA port map(HA_sum(3),P_AB(10,5),P_AB(11,4),FA_sum(47),FA_Co(47));
  FA49 : FA port map(HA_sum(4),HA_Co(3),P_AB(11,5),FA_sum(48),FA_Co(48));
  FA50 : FA port map(P_AB(10,7),HA_Co(4),P_AB(11,6),FA_sum(49),FA_Co(49));
  FA51 : FA port map(P_AB(9,9),P_AB(10,8),P_AB(11,7),FA_sum(50),FA_Co(50));
  FA52 : FA port map(P_AB(9,10),P_AB(10,9),P_AB(11,8),FA_sum(51),FA_Co(51));
  FA53 : FA port map(P_AB(9,11),P_AB(10,10),P_AB(11,9),FA_sum(52),FA_Co(52));
  FA54 : FA port map(P_AB(11,10),P_AB(12,9),P_AB(13,8),FA_sum(53),FA_Co(53));
  FA55 : FA port map(P_AB(9,3),P_AB(10,2),P_AB(11,1),FA_sum(54),FA_Co(54));
  FA56 : FA port map(P_AB(10,3),P_AB(11,2),P_AB(12,1),FA_sum(55),FA_Co(55));
  FA57 : FA port map(P_AB(11,3),P_AB(12,2),P_AB(13,1),FA_sum(56),FA_Co(56));
  FA58 : FA port map(P_AB(12,3),P_AB(13,2),P_AB(14,1),FA_sum(57),FA_Co(57));
  FA59 : FA port map(P_AB(12,4),P_AB(13,3),P_AB(14,2),FA_sum(58),FA_Co(58));
  FA60 : FA port map(P_AB(12,5),P_AB(13,4),P_AB(14,3),FA_sum(59),FA_Co(59));
  FA61 : FA port map(P_AB(12,6),P_AB(13,5),P_AB(14,4),FA_sum(60),FA_Co(60));
  FA62 : FA port map(P_AB(12,7),P_AB(13,6),P_AB(14,5),FA_sum(61),FA_Co(61));
  FA63 : FA port map(P_AB(12,8),P_AB(13,7),P_AB(14,6),FA_sum(62),FA_Co(62));
  
-- 3rd layer FA's and HA's
  HA10 : HA port map(C(5),P_AB(0,5),HA_sum(9),HA_Co(9));
  HA11 : HA port map(P_AB(2,4),P_AB(3,3),HA_sum(10),HA_Co(10));
  HA12 : HA port map(P_AB(5,2),P_AB(6,1),HA_sum(11),HA_Co(11));
  
  FA64 : FA port map(C(6),P_AB(0,6),P_AB(1,5),FA_sum(63),FA_Co(63));
  FA65 : FA port map(C(7),P_AB(0,7),P_AB(1,6),FA_sum(64),FA_Co(64));
  FA66 : FA port map(HA_sum(5),P_AB(1,7),P_AB(2,6),FA_sum(65),FA_Co(65));
  FA67 : FA port map(FA_sum(15),HA_Co(5),HA_sum(6),FA_sum(66),FA_Co(66));
  FA68 : FA port map(FA_sum(16),FA_Co(15),FA_sum(30),FA_sum(67),FA_Co(67));
  FA69 : FA port map(FA_sum(17),FA_Co(16),FA_sum(31),FA_sum(68),FA_Co(68));
  FA70 : FA port map(FA_sum(18),FA_Co(17),FA_sum(32),FA_sum(69),FA_Co(69));
  FA71 : FA port map(FA_sum(19),FA_Co(18),FA_sum(33),FA_sum(70),FA_Co(70));
  FA72 : FA port map(FA_sum(20),FA_Co(19),FA_sum(34),FA_sum(71),FA_Co(71));
  FA73 : FA port map(FA_sum(21),FA_Co(20),FA_sum(35),FA_sum(72),FA_Co(72));
  FA74 : FA port map(FA_sum(22),FA_Co(21),FA_sum(36),FA_sum(73),FA_Co(73)); 
  FA75 : FA port map(FA_sum(23),FA_Co(22),FA_sum(37),FA_sum(74),FA_Co(74));
  FA76 : FA port map(FA_sum(24),FA_Co(23),FA_sum(38),FA_sum(75),FA_Co(75));
  FA77 : FA port map(FA_sum(25),FA_Co(24),FA_sum(39),FA_sum(76),FA_Co(76));
  FA78 : FA port map(FA_sum(26),FA_Co(25),FA_sum(40),FA_sum(77),FA_Co(77));
  FA79 : FA port map(FA_sum(27),FA_Co(26),FA_sum(41),FA_sum(78),FA_Co(78));
  FA80 : FA port map(FA_sum(28),FA_Co(27),FA_sum(42),FA_sum(79),FA_Co(79));
  FA81 : FA port map(FA_sum(29),FA_Co(28),P_AB(10,13),FA_sum(80),FA_Co(80));
  FA82 : FA port map(C(24),FA_Co(29),P_AB(9,15),FA_sum(81),FA_Co(81));
  FA83 : FA port map(C(25),P_AB(10,15),P_AB(11,14),FA_sum(82),FA_Co(82));
  FA84 : FA port map(C(26),P_AB(11,15),P_AB(12,14),FA_sum(83),FA_Co(83));
  FA85 : FA port map(P_AB(2,5),P_AB(3,4),P_AB(4,3),FA_sum(84),FA_Co(84));
  FA86 : FA port map(P_AB(3,5),P_AB(4,4),P_AB(5,3),FA_sum(85),FA_Co(85));
  FA87 : FA port map(P_AB(4,5),P_AB(5,4),P_AB(6,3),FA_sum(86),FA_Co(86));
  FA88 : FA port map(HA_Co(6),HA_sum(7),P_AB(7,3),FA_sum(87),FA_Co(87));
  FA89 : FA port map(FA_Co(30),FA_sum(43),HA_Co(7),FA_sum(88),FA_Co(88));
  FA90 : FA port map(FA_Co(31),FA_sum(44),FA_Co(43),FA_sum(89),FA_Co(89));
  FA91 : FA port map(FA_Co(32),FA_sum(45),FA_Co(44),FA_sum(90),FA_Co(90));
  FA92 : FA port map(FA_Co(33),FA_sum(46),FA_Co(45),FA_sum(91),FA_Co(91));
  FA93 : FA port map(FA_Co(34),FA_sum(47),FA_Co(46),FA_sum(92),FA_Co(92));
  FA94 : FA port map(FA_Co(35),FA_sum(48),FA_Co(47),FA_sum(93),FA_Co(93));
  FA95 : FA port map(FA_Co(36),FA_sum(49),FA_Co(48),FA_sum(94),FA_Co(94));
  FA96 : FA port map(FA_Co(37),FA_sum(50),FA_Co(49),FA_sum(95),FA_Co(95));
  FA97 : FA port map(FA_Co(38),FA_sum(51),FA_Co(50),FA_sum(96),FA_Co(96));
  FA98 : FA port map(FA_Co(39),FA_sum(52),FA_Co(51),FA_sum(97),FA_Co(97));
  FA99 : FA port map(FA_Co(40),FA_sum(53),FA_Co(52),FA_sum(98),FA_Co(98));
  FA100 : FA port map(FA_Co(41),P_AB(12,10),FA_Co(53),FA_sum(99),FA_Co(99));
  FA101 : FA port map(FA_Co(42),P_AB(11,12),P_AB(12,11),FA_sum(100),FA_Co(100));
  FA102 : FA port map(P_AB(10,14),P_AB(11,13),P_AB(12,12),FA_sum(101),FA_Co(101));
  FA103 : FA port map(P_AB(12,13),P_AB(13,12),P_AB(14,11),FA_sum(102),FA_Co(102));
  FA104 : FA port map(P_AB(6,2),P_AB(7,1),P_AB(8,0),FA_sum(103),FA_Co(103));
  FA105 : FA port map(P_AB(7,2),P_AB(8,1),P_AB(9,0),FA_sum(104),FA_Co(104));
  FA106 : FA port map(P_AB(8,2),P_AB(9,1),P_AB(10,0),FA_sum(105),FA_Co(105));
  FA107 : FA port map(HA_sum(8),P_AB(10,1),P_AB(11,0),FA_sum(106),FA_Co(106));
  FA108 : FA port map(FA_sum(54),HA_Co(8),P_AB(12,0),FA_sum(107),FA_Co(107));
  FA109 : FA port map(FA_sum(55),FA_Co(54),P_AB(13,0),FA_sum(108),FA_Co(108));
  FA110 : FA port map(FA_sum(56),FA_Co(55),P_AB(14,0),FA_sum(109),FA_Co(109));
  FA111 : FA port map(FA_sum(57),FA_Co(56),P_AB(15,0),FA_sum(110),FA_Co(110));
  FA112 : FA port map(FA_sum(58),FA_Co(57),P_AB(15,1),FA_sum(111),FA_Co(111));
  FA113 : FA port map(FA_sum(59),FA_Co(58),P_AB(15,2),FA_sum(112),FA_Co(112));
  FA114 : FA port map(FA_sum(60),FA_Co(59),P_AB(15,3),FA_sum(113),FA_Co(113));
  FA115 : FA port map(FA_sum(61),FA_Co(60),P_AB(15,4),FA_sum(114),FA_Co(114));
  FA116 : FA port map(FA_sum(62),FA_Co(61),P_AB(15,5),FA_sum(115),FA_Co(115));
  FA117 : FA port map(P_AB(14,7),FA_Co(62),P_AB(15,6),FA_sum(116),FA_Co(116));
  FA118 : FA port map(P_AB(13,9),P_AB(14,8),P_AB(15,7),FA_sum(117),FA_Co(117));
  FA119 : FA port map(P_AB(13,10),P_AB(14,9),P_AB(15,8),FA_sum(118),FA_Co(118));
  FA120 : FA port map(P_AB(13,11),P_AB(14,10),P_AB(15,9),FA_sum(119),FA_Co(119));
  
-- 3rd layer FA's and HA's
  HA13 : HA port map(C(3),P_AB(0,3),HA_sum(12),HA_Co(12));
  HA14 : HA port map(P_AB(2,2),P_AB(3,1),HA_sum(13),HA_Co(13));
  
  FA121 : FA port map(C(4),P_AB(0,4),P_AB(1,3),FA_sum(120),FA_Co(120));
  FA122 : FA port map(HA_sum(9),P_AB(1,4),P_AB(2,3),FA_sum(121),FA_Co(121));
  FA123 : FA port map(FA_sum(63),HA_Co(9),HA_sum(10),FA_sum(122),FA_Co(122));
  FA124 : FA port map(FA_sum(64),FA_Co(63),FA_sum(84),FA_sum(123),FA_Co(123));
  FA125 : FA port map(FA_sum(65),FA_Co(64),FA_sum(85),FA_sum(124),FA_Co(124));
  FA126 : FA port map(FA_sum(66),FA_Co(65),FA_sum(86),FA_sum(125),FA_Co(125));
  FA127 : FA port map(FA_sum(67),FA_Co(66),FA_sum(87),FA_sum(126),FA_Co(126));
  FA128 : FA port map(FA_sum(68),FA_Co(67),FA_sum(88),FA_sum(127),FA_Co(127));
  FA129 : FA port map(FA_sum(69),FA_Co(68),FA_sum(89),FA_sum(128),FA_Co(128));
  FA130 : FA port map(FA_sum(70),FA_Co(69),FA_sum(90),FA_sum(129),FA_Co(129));
  FA131 : FA port map(FA_sum(71),FA_Co(70),FA_sum(91),FA_sum(130),FA_Co(130));
  FA132 : FA port map(FA_sum(72),FA_Co(71),FA_sum(92),FA_sum(131),FA_Co(131));
  FA133 : FA port map(FA_sum(73),FA_Co(72),FA_sum(93),FA_sum(132),FA_Co(132));
  FA134 : FA port map(FA_sum(74),FA_Co(73),FA_sum(94),FA_sum(133),FA_Co(133));
  FA135 : FA port map(FA_sum(75),FA_Co(74),FA_sum(95),FA_sum(134),FA_Co(134));
  FA136 : FA port map(FA_sum(76),FA_Co(75),FA_sum(96),FA_sum(135),FA_Co(135));
  FA137 : FA port map(FA_sum(77),FA_Co(76),FA_sum(97),FA_sum(136),FA_Co(136));
  FA138 : FA port map(FA_sum(78),FA_Co(77),FA_sum(98),FA_sum(137),FA_Co(137));
  FA139 : FA port map(FA_sum(79),FA_Co(78),FA_sum(99),FA_sum(138),FA_Co(138));
  FA140 : FA port map(FA_sum(80),FA_Co(79),FA_sum(100),FA_sum(139),FA_Co(139));
  FA141 : FA port map(FA_sum(81),FA_Co(80),FA_sum(101),FA_sum(140),FA_Co(140));
  FA142 : FA port map(FA_sum(82),FA_Co(81),FA_sum(102),FA_sum(141),FA_Co(141));
  FA143 : FA port map(FA_sum(83),FA_Co(82),P_AB(13,13),FA_sum(142),FA_Co(142));
  FA144 : FA port map(C(27),FA_Co(83),P_AB(12,15),FA_sum(143),FA_Co(143));
  FA145 : FA port map(C(28),P_AB(13,15),P_AB(14,14),FA_sum(144),FA_Co(144));
  FA146 : FA port map(P_AB(3,2),P_AB(4,1),P_AB(5,0),FA_sum(145),FA_Co(145));
  FA147 : FA port map(P_AB(4,2),P_AB(5,1),P_AB(6,0),FA_sum(146),FA_Co(146));
  FA148 : FA port map(HA_Co(10),HA_sum(11),P_AB(7,0),FA_sum(147),FA_Co(147));
  FA149 : FA port map(FA_Co(84),FA_sum(103),HA_Co(11),FA_sum(148),FA_Co(148));
  FA150 : FA port map(FA_Co(85),FA_sum(104),FA_Co(103),FA_sum(149),FA_Co(149));
  FA151 : FA port map(FA_Co(86),FA_sum(105),FA_Co(104),FA_sum(150),FA_Co(150));
  FA152 : FA port map(FA_Co(87),FA_sum(106),FA_Co(105),FA_sum(151),FA_Co(151));
  FA153 : FA port map(FA_Co(88),FA_sum(107),FA_Co(106),FA_sum(152),FA_Co(152));
  FA154 : FA port map(FA_Co(89),FA_sum(108),FA_Co(107),FA_sum(153),FA_Co(153));
  FA155 : FA port map(FA_Co(90),FA_sum(109),FA_Co(108),FA_sum(154),FA_Co(154));
  FA156 : FA port map(FA_Co(91),FA_sum(110),FA_Co(109),FA_sum(155),FA_Co(155));
  FA157 : FA port map(FA_Co(92),FA_sum(111),FA_Co(110),FA_sum(156),FA_Co(156));
  FA158 : FA port map(FA_Co(93),FA_sum(112),FA_Co(111),FA_sum(157),FA_Co(157));
  FA159 : FA port map(FA_Co(94),FA_sum(113),FA_Co(112),FA_sum(158),FA_Co(158));
  FA160 : FA port map(FA_Co(95),FA_sum(114),FA_Co(113),FA_sum(159),FA_Co(159));
  FA161 : FA port map(FA_Co(96),FA_sum(115),FA_Co(114),FA_sum(160),FA_Co(160));
  FA162 : FA port map(FA_Co(97),FA_sum(116),FA_Co(115),FA_sum(161),FA_Co(161));
  FA163 : FA port map(FA_Co(98),FA_sum(117),FA_Co(116),FA_sum(162),FA_Co(162));
  FA164 : FA port map(FA_Co(99),FA_sum(118),FA_Co(117),FA_sum(163),FA_Co(163));
  FA165 : FA port map(FA_Co(100),FA_sum(119),FA_Co(118),FA_sum(164),FA_Co(164));
  FA166 : FA port map(FA_Co(101),P_AB(15,10),FA_Co(119),FA_sum(165),FA_Co(165));
  FA167 : FA port map(FA_Co(102),P_AB(14,12),P_AB(15,11),FA_sum(166),FA_Co(166));
  FA168 : FA port map(P_AB(13,14),P_AB(14,13),P_AB(15,12),FA_sum(167),FA_Co(167));
  
-- 4rd layer FA's and HA's  
  HA15 : HA port map(C(2),P_AB(0,2),HA_sum(14),HA_Co(14));
  
  FA169 : FA port map(HA_sum(12),P_AB(1,2),P_AB(2,1),FA_sum(168),FA_Co(168));
  FA170 : FA port map(FA_sum(120),HA_Co(12),HA_sum(13),FA_sum(169),FA_Co(169));
  FA171 : FA port map(FA_sum(121),FA_Co(120),FA_sum(145),FA_sum(170),FA_Co(170));
  FA172 : FA port map(FA_sum(122),FA_Co(121),FA_sum(146),FA_sum(171),FA_Co(171));
  FA173 : FA port map(FA_sum(123),FA_Co(122),FA_sum(147),FA_sum(172),FA_Co(172));
  FA174 : FA port map(FA_sum(124),FA_Co(123),FA_sum(148),FA_sum(173),FA_Co(173));
  FA175 : FA port map(FA_sum(125),FA_Co(124),FA_sum(149),FA_sum(174),FA_Co(174));
  FA176 : FA port map(FA_sum(126),FA_Co(125),FA_sum(150),FA_sum(175),FA_Co(175));
  FA177 : FA port map(FA_sum(127),FA_Co(126),FA_sum(151),FA_sum(176),FA_Co(176));
  FA178 : FA port map(FA_sum(128),FA_Co(127),FA_sum(152),FA_sum(177),FA_Co(177));
  FA179 : FA port map(FA_sum(129),FA_Co(128),FA_sum(153),FA_sum(178),FA_Co(178));
  FA180 : FA port map(FA_sum(130),FA_Co(129),FA_sum(154),FA_sum(179),FA_Co(179));
  FA181 : FA port map(FA_sum(131),FA_Co(130),FA_sum(155),FA_sum(180),FA_Co(180));
  FA182 : FA port map(FA_sum(132),FA_Co(131),FA_sum(156),FA_sum(181),FA_Co(181));
  FA183 : FA port map(FA_sum(133),FA_Co(132),FA_sum(157),FA_sum(182),FA_Co(182));
  FA184 : FA port map(FA_sum(134),FA_Co(133),FA_sum(158),FA_sum(183),FA_Co(183));
  FA185 : FA port map(FA_sum(135),FA_Co(134),FA_sum(159),FA_sum(184),FA_Co(184));
  FA186 : FA port map(FA_sum(136),FA_Co(135),FA_sum(160),FA_sum(185),FA_Co(185));
  FA187 : FA port map(FA_sum(137),FA_Co(136),FA_sum(161),FA_sum(186),FA_Co(186));
  FA188 : FA port map(FA_sum(138),FA_Co(137),FA_sum(162),FA_sum(187),FA_Co(187));
  FA189 : FA port map(FA_sum(139),FA_Co(138),FA_sum(163),FA_sum(188),FA_Co(188));
  FA190 : FA port map(FA_sum(140),FA_Co(139),FA_sum(164),FA_sum(189),FA_Co(189));
  FA191 : FA port map(FA_sum(141),FA_Co(140),FA_sum(165),FA_sum(190),FA_Co(190));
  FA192 : FA port map(FA_sum(142),FA_Co(141),FA_sum(166),FA_sum(191),FA_Co(191));
  FA193 : FA port map(FA_sum(143),FA_Co(142),FA_sum(167),FA_sum(192),FA_Co(192));
  FA194 : FA port map(FA_sum(144),FA_Co(143),P_AB(15,13),FA_sum(193),FA_Co(193));
  FA195 : FA port map(C(29),FA_Co(144),P_AB(14,15),FA_sum(194),FA_Co(194));
  
-- 4rd layer FA's and HA's    
  HA16 : HA port map(C(1),P_AB(0,1),HA_sum(15),HA_Co(15));
  FA196 : FA port map(HA_sum(14),P_AB(1,1),P_AB(2,0),FA_sum(195),FA_Co(195));
  FA197 : FA port map(FA_sum(168),HA_Co(14),P_AB(3,0),FA_sum(196),FA_Co(196));
  FA198 : FA port map(FA_sum(169),FA_Co(168),P_AB(4,0),FA_sum(197),FA_Co(197));
  FA199 : FA port map(FA_sum(170),FA_Co(169),HA_Co(13),FA_sum(198),FA_Co(198));
  FA200 : FA port map(FA_sum(171),FA_Co(170),FA_Co(145),FA_sum(199),FA_Co(199));
  FA201 : FA port map(FA_sum(172),FA_Co(171),FA_Co(146),FA_sum(200),FA_Co(200));
  FA202 : FA port map(FA_sum(173),FA_Co(172),FA_Co(147),FA_sum(201),FA_Co(201));
  FA203 : FA port map(FA_sum(174),FA_Co(173),FA_Co(148),FA_sum(202),FA_Co(202));
  FA204 : FA port map(FA_sum(175),FA_Co(174),FA_Co(149),FA_sum(203),FA_Co(203));
  FA205 : FA port map(FA_sum(176),FA_Co(175),FA_Co(150),FA_sum(204),FA_Co(204));
  FA206 : FA port map(FA_sum(177),FA_Co(176),FA_Co(151),FA_sum(205),FA_Co(205));
  FA207 : FA port map(FA_sum(178),FA_Co(177),FA_Co(152),FA_sum(206),FA_Co(206));
  FA208 : FA port map(FA_sum(179),FA_Co(178),FA_Co(153),FA_sum(207),FA_Co(207));
  FA209 : FA port map(FA_sum(180),FA_Co(179),FA_Co(154),FA_sum(208),FA_Co(208));
  FA210 : FA port map(FA_sum(181),FA_Co(180),FA_Co(155),FA_sum(209),FA_Co(209));
  FA211 : FA port map(FA_sum(182),FA_Co(181),FA_Co(156),FA_sum(210),FA_Co(210));
  FA212 : FA port map(FA_sum(183),FA_Co(182),FA_Co(157),FA_sum(211),FA_Co(211));
  FA213 : FA port map(FA_sum(184),FA_Co(183),FA_Co(158),FA_sum(212),FA_Co(212));
  FA214 : FA port map(FA_sum(185),FA_Co(184),FA_Co(159),FA_sum(213),FA_Co(213));
  FA215 : FA port map(FA_sum(186),FA_Co(185),FA_Co(160),FA_sum(214),FA_Co(214));
  FA216 : FA port map(FA_sum(187),FA_Co(186),FA_Co(161),FA_sum(215),FA_Co(215));
  FA217 : FA port map(FA_sum(188),FA_Co(187),FA_Co(162),FA_sum(216),FA_Co(216));
  FA218 : FA port map(FA_sum(189),FA_Co(188),FA_Co(163),FA_sum(217),FA_Co(217));
  FA219 : FA port map(FA_sum(190),FA_Co(189),FA_Co(164),FA_sum(218),FA_Co(218));
  FA220 : FA port map(FA_sum(191),FA_Co(190),FA_Co(165),FA_sum(219),FA_Co(219));
  FA221 : FA port map(FA_sum(192),FA_Co(191),FA_Co(166),FA_sum(220),FA_Co(220));
  FA222 : FA port map(FA_sum(193),FA_Co(192),FA_Co(167),FA_sum(221),FA_Co(221));
  FA223 : FA port map(FA_sum(194),FA_Co(193),P_AB(15,14),FA_sum(222),FA_Co(222));
  FA224 : FA port map(C(30),FA_Co(194),P_AB(15,15),FA_sum(223),FA_Co(223));
  
-- making two 32bit arrays for final addition  
  MAC_TA(0) <= C(0);				MAC_TB(0) <= P_AB(0,0); 	--	index 0
  MAC_TA(1) <= HA_sum(15);		MAC_TB(1) <= P_AB(1,0); 	--	index 1
  MAC_TA(2) <= FA_sum(195);	MAC_TB(2) <= HA_Co(15); 	--	index 2
  MAC_TA(3) <= FA_sum(196);	MAC_TB(3) <= FA_Co(195); 	-- index 3
  MAC_TA(4) <= FA_sum(197);	MAC_TB(4) <= FA_Co(196); 	-- index 4
  MAC_TA(5) <= FA_sum(198);	MAC_TB(5) <= FA_Co(197); 	-- index 5
  MAC_TA(6) <= FA_sum(199);	MAC_TB(6) <= FA_Co(198); 	-- index 6
  MAC_TA(7) <= FA_sum(200);	MAC_TB(7) <= FA_Co(199); 	-- index 7
  MAC_TA(8) <= FA_sum(201);	MAC_TB(8) <= FA_Co(200); 	-- index 8
  MAC_TA(9) <= FA_sum(202);	MAC_TB(9) <= FA_Co(201); 	-- index 9
  MAC_TA(10) <= FA_sum(203);	MAC_TB(10) <= FA_Co(202); 	-- index 10

  MAC_TA(11) <= FA_sum(204);	MAC_TB(11) <= FA_Co(203);	--	index 11
  MAC_TA(12) <= FA_sum(205);	MAC_TB(12) <= FA_Co(204);	--	index 12
  MAC_TA(13) <= FA_sum(206);	MAC_TB(13) <= FA_Co(205); 	-- index 13
  MAC_TA(14) <= FA_sum(207);	MAC_TB(14) <= FA_Co(206); 	-- index 14
  MAC_TA(15) <= FA_sum(208);	MAC_TB(15) <= FA_Co(207); 	-- index 15
  MAC_TA(16) <= FA_sum(209);	MAC_TB(16) <= FA_Co(208); 	-- index 16
  MAC_TA(17) <= FA_sum(210);	MAC_TB(17) <= FA_Co(209); 	-- index 17
  MAC_TA(18) <= FA_sum(211);	MAC_TB(18) <= FA_Co(210); 	-- index 18
  MAC_TA(19) <= FA_sum(212);	MAC_TB(19) <= FA_Co(211); 	-- index 19
  MAC_TA(20) <= FA_sum(213);	MAC_TB(20) <= FA_Co(212); 	-- index 20

  MAC_TA(21) <= FA_sum(214);	MAC_TB(21) <= FA_Co(213);	--	index 21
  MAC_TA(22) <= FA_sum(215);	MAC_TB(22) <= FA_Co(214);	--	index 22
  MAC_TA(23) <= FA_sum(216);	MAC_TB(23) <= FA_Co(215); 	-- index 23
  MAC_TA(24) <= FA_sum(217);	MAC_TB(24) <= FA_Co(216); 	-- index 24
  MAC_TA(25) <= FA_sum(218);	MAC_TB(25) <= FA_Co(217); 	-- index 25
  MAC_TA(26) <= FA_sum(219);	MAC_TB(26) <= FA_Co(218); 	-- index 26
  MAC_TA(27) <= FA_sum(220);	MAC_TB(27) <= FA_Co(219); 	-- index 27
  MAC_TA(28) <= FA_sum(221);	MAC_TB(28) <= FA_Co(220); 	-- index 28
  MAC_TA(29) <= FA_sum(222);	MAC_TB(29) <= FA_Co(221); 	-- index 29
  MAC_TA(30) <= FA_sum(223);	MAC_TB(30) <= FA_Co(222); 	-- index 30  

  MAC_TA(31) <= C(31);	MAC_TB(31) <= FA_Co(223); 			-- index 31
  
  MAC_A <= MAC_TA; MAC_B <= MAC_TB;
  
  BK0 : entity work.BK_addr_23m1200(st1)
							port map(MAC_TA,MAC_TB,'0',MAC_out,BK_Cinrl,MAC_Carry_out);
  
end architecture;
