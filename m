Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:59424 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2LJJpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 04:45:50 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: add regulatory rule for ETSI members on 60gHz band
Date: Mon, 10 Dec 2012 11:45:46 +0200
Message-ID: <1573921.0GjqNuABMd@lx-vladimir> (sfid-20121210_104554_770780_B8ABD895)
In-Reply-To: <8774585.BvFN3Opv12@lx-vladimir>
References: <8774585.BvFN3Opv12@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Next is European countries.

>From fb3b4f18ad755be4236204bb2006e55eda3a84be Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 10 Dec 2012 11:37:55 +0200
Subject: [PATCH] wireless-regdb: add regulatory rule for ETSI members on
 60gHz band

For the 60gHz band, regulation defined in the "Etsi En 302 567"
http://docsfiles.com/pdf_final_draft_etsi_en_302_567.html

It defines for the frequency range 57 GHz to 66 GHz,
Max. power level (EIRP) for
indoor only: 40 dBm, and indoor/outdoor: 25 dBm

This patch apply this to the full ETSI member countries:

The EU member states:
Austria, Belgium, Bulgaria, Cyprus, Czech Republic, Denmark,
Estonia, Finland, France, Germany, Greece, Hungary, Ireland,
Italy, Latvia, Lithuania, Luxembourg, Malta, Netherlands,
Poland, Portugal, Romania, Slovakia, Slovenia, Spain, Sweden,
United Kingdom

plus:
Andorra, Iceland, Norway, Switzerland, Croatia,
Bosnia and Herzegovina, Serbia, Macedonia,
Ukraine, Turkey, Georgia

Final country codes list:

AD
AT
BA
BE
BG
CH
CY
CZ
DE
DK
EE
ES
FI
FR
GB
GE
GR
HR
HU
IE
IS
IT
LT
LU
LV
MK
MT
NL
NO
PL
PT
RO
RS
SE
SI
SK
TR
UA

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 db.txt |  118 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/db.txt b/db.txt
index b97255d..c403773 100644
--- a/db.txt
+++ b/db.txt
@@ -12,6 +12,11 @@ country 00:
         (5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
 
 
+country AD:
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
+
 country AE:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
@@ -44,6 +49,9 @@ country AT: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country AU:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -67,6 +75,9 @@ country BA: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country BB:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -82,12 +93,18 @@ country BE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country BG: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 23)
 	(5250 - 5290 @ 40), (N/A, 23), DFS
 	(5490 - 5710 @ 40), (N/A, 30), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country BH:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -139,6 +156,9 @@ country CH: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country CL:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -173,6 +193,9 @@ country CY: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 # Data from http://www.ctu.eu/164/download/VOR/VOR-12-08-2005-34.pdf
 # and http://www.ctu.eu/164/download/VOR/VOR-12-05-2007-6-AN.pdf
@@ -183,6 +206,9 @@ country CZ: DFS-ETSI
 	(5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 # Data from "Frequenznutzungsplan" (as published in April 2008), downloaded from
 # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publicationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
@@ -205,12 +231,18 @@ country DE: DFS-ETSI
 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
 	# entries 308002, 309001 and 310003
 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country DK: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country DO:
 	(2402 - 2472 @ 40), (3, 27)
@@ -232,6 +264,9 @@ country EE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country EG:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -243,29 +278,44 @@ country ES: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country FI: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country FR: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country GE:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 18)
 	(5250 - 5330 @ 40), (N/A, 18), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country GB: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country GD:
 	(2402 - 2472 @ 40), (3, 27)
@@ -279,6 +329,9 @@ country GR: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country GL: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -317,6 +370,9 @@ country HR: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country HT:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -329,6 +385,9 @@ country HU: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country ID:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -338,6 +397,9 @@ country IE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country IL:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -355,6 +417,9 @@ country IS: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country IR:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -365,6 +430,9 @@ country IT: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country JM:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -445,18 +513,27 @@ country LT: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country LU: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country LV: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country MC: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -477,12 +554,18 @@ country MK: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country MT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country MY:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -500,12 +583,18 @@ country NL: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20), NO-OUTDOOR
 	(5250 - 5330 @ 40), (N/A, 20), NO-OUTDOOR, DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country NO: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country NP:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -553,12 +642,18 @@ country PL: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country PT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country PR:
 	(2402 - 2472 @ 40), (3, 27)
@@ -575,6 +670,14 @@ country RO: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
+
+country RS:
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country RU:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -595,6 +698,9 @@ country SE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country SG:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -607,12 +713,18 @@ country SI: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country SK: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country SV:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -651,9 +763,15 @@ country TR: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 20), (N/A, 20)
 	(5250 - 5330 @ 20), (N/A, 20), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country UA:
 	(2402 - 2482 @ 40), (N/A, 20)
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+        (57240 - 65880 @ 2160), (N/A, 25)
 
 country US: DFS-FCC
 	(2402 - 2472 @ 40), (3, 27)
-- 
1.7.10.4


