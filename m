Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxm.seznam.cz ([77.75.72.45]:46673 "EHLO mxm.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbYK0XNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 18:13:13 -0500
Cc: linux-wireless@vger.kernel.org
To: linville@tuxdriver.com
Date: Thu, 27 Nov 2008 22:23:14 +0100 (CET)
From: =?iso-8859-2?Q?Carlos=20Lau=E9?= <CarlosL@seznam.cz>
Subject: =?us-ascii?Q?wireless=2Dregdb=3A=20Update=20regulatory=20rules=20for=20Czech=20Republic=20=28CZ=29=20on=205GHz?=
Mime-Version: 1.0
Message-Id: <610.1477-13200-1232669665-1227820994@seznam.cz> (sfid-20081128_001318_245944_E312D496)
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

There seems to be outdated information in the regulatory database for C=
Z. According to the new regulatory laws, which can be found at http://w=
ww.ctu.cz/1/download/Opatreni obecne povahy/VO_R_12_08_2005_34.pdf (pag=
e 2) and http://www.ctu.cz/1/download/OOP/Rok_2007/VO_R_10_03_2007_4.pd=
f (page 3), for 5GHz the table should look like this:

5150.000 - 5250.000 ; 40.000 ; NO-OUTDOOR ; N/A ; 23.00 (200.00 mW)
5250.000 - 5350.000 ; 40.000 ; NO-OUTDOOR,DFS ; N/A ; 23.00 (200.00 mW)
5470.000 - 5725.000 ; 40.000 ; DFS ; N/A ; 30.00 (1000.00 mW)
5725.000 - 5875.000 ; 40.000 ;  ; N/A ; 14.00(25.00 mW)

if there are any difference between values in dBm and in mW, please con=
sider the value in mW as the right value.=20

* The values for 5250-5350MHz and 5470-5875MHz are valid only if the de=
vice is capable of automatic output power regulation (ie.iwconfig wlan0=
 power auto). If there isn't a way to assure this, then the maximum pow=
er output limit must be set to a value 3dB lower for ranges 5250-5350MH=
z (20dBm) and 5470-5875MHz.(27dBm).

Carlos Lau=E9
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
