Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58703 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbaJ1ITn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 04:19:43 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	<wireless-regdb@lists.infradead.org>
Subject: Re: [PATCH] wireless-regdb: add regulatory rule for ETSI members on 60GHz band
Date: Tue, 28 Oct 2014 10:19:35 +0200
Message-ID: <2900736.zZ5BmU3opc@lx-wigig-72> (sfid-20141028_091952_775293_9C4321A1)
In-Reply-To: <20141027172636.GA28300@tuxdriver.com>
References: <543D170A.6060709@gmail.com> <1465375.2aSLY3brRR@lx-wigig-72> <20141027172636.GA28300@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, October 27, 2014 01:26:37 PM John W. Linville wrote:
> > On Tuesday, October 14, 2014 02:28:58 PM Xose Vazquez Perez wrote:
> 
> > > "(57240 - 65880 @ 2160), (40), NO-OUTDOOR" should(must) be replaced by:
> > > "(57000 - 66000 @ 2160), (40)"
> 
> Would someone like to post a patch to that effect?
> 
See below


>From 6bccae032be4c9f99cddfdf55ff781316cabe20d Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Tue, 28 Oct 2014 10:17:30 +0200
Subject: [PATCH] wireless-regdb: update 60GHz rules for EU

Comply to final document: Etsi En 302 567

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 db.txt | 76 +++++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/db.txt b/db.txt
index 8e83e0c..aef6d06 100644
--- a/db.txt
+++ b/db.txt
@@ -19,7 +19,7 @@ country 00:
 
 country AD:
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country AE: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -58,7 +58,7 @@ country AT: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country AU:
 	(2402 - 2482 @ 40), (20)
@@ -84,7 +84,7 @@ country BA: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country BB: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -102,14 +102,14 @@ country BE: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country BG: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20)
 	(5250 - 5330 @ 80), (20), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country BH: DFS-JP
 	(2402 - 2482 @ 40), (20)
@@ -162,7 +162,7 @@ country CH: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country CL: DFS-JP
 	(2402 - 2482 @ 40), (20)
@@ -201,7 +201,7 @@ country CY: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 # Data from http://www.ctu.eu/164/download/VOR/VOR-12-08-2005-34.pdf
 # and http://www.ctu.eu/164/download/VOR/VOR-12-05-2007-6-AN.pdf
@@ -213,7 +213,7 @@ country CZ: DFS-ETSI
 	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS
 	(5470 - 5725 @ 80), (500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 # Data from "Frequenznutzungsplan" (as published in April 2008), downloaded from
 # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publicationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
@@ -237,7 +237,7 @@ country DE: DFS-ETSI
 	# entries 308002, 309001 and 310003
 	(5470 - 5725 @ 80), (500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country DK: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -245,7 +245,7 @@ country DK: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country DO: DFS-FCC
 	(2402 - 2472 @ 40), (30)
@@ -272,7 +272,7 @@ country EE: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country EG: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -285,7 +285,7 @@ country ES: DFS-ETSI
 	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS
 	(5470 - 5725 @ 80), (500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country FI: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -293,7 +293,7 @@ country FI: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country FR: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -301,14 +301,14 @@ country FR: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country GE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (18)
 	(5250 - 5330 @ 80), (18), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country GB: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -316,7 +316,7 @@ country GB: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country GD: DFS-FCC
 	(2402 - 2472 @ 40), (30)
@@ -331,7 +331,7 @@ country GR: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country GL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -372,7 +372,7 @@ country HR: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country HT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -386,7 +386,7 @@ country HU: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country ID: DFS-JP
 	# ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf
@@ -399,7 +399,7 @@ country IE: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country IL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -418,7 +418,7 @@ country IS: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country IR: DFS-JP
 	(2402 - 2482 @ 40), (20)
@@ -430,7 +430,7 @@ country IT: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country JM: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -513,7 +513,7 @@ country LT: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country LU: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -521,7 +521,7 @@ country LU: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country LV: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -529,7 +529,7 @@ country LV: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country MC: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -554,7 +554,7 @@ country MK: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country MT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -562,7 +562,7 @@ country MT: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country MY: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -583,7 +583,7 @@ country NL: DFS-ETSI
 	(5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 # Data from http://www.lovdata.no/dokument/SF/forskrift/2012-01-19-77
 # Power at 5250 - 5350 MHz, 5470 - 5725 MHz and 5815 – 5850 MHz can
@@ -598,7 +598,7 @@ country NO: DFS-ETSI
 	(5815 - 5850 @ 35), (2000 mW), DFS
 	(17100 - 17300 @ 200), (100 mW)
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country NP: DFS-JP
 	(2402 - 2482 @ 40), (20)
@@ -656,7 +656,7 @@ country PL: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country PT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -664,7 +664,7 @@ country PT: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country PR: DFS-FCC
 	(2402 - 2472 @ 40), (30)
@@ -683,7 +683,7 @@ country RO: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 
 # Source:
@@ -693,7 +693,7 @@ country RS: DFS-ETSI
 	(5150 - 5350 @ 40), (200 mW), NO-OUTDOOR
 	(5470 - 5725 @ 20), (1000 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country RU: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -721,7 +721,7 @@ country SE: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country SG: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -736,7 +736,7 @@ country SI: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country SK: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
@@ -744,7 +744,7 @@ country SK: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country SV: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -787,7 +787,7 @@ country TR: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
  
 # Source:
 # #914 / 06 Sep 2007: http://www.ucrf.gov.ua/uk/doc/nkrz/1196068874
@@ -802,7 +802,7 @@ country UA: DFS-ETSI
 	(5490 - 5670 @ 80), (20), DFS
 	(5735 - 5835 @ 80), (20)
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40)
 
 country US: DFS-FCC
 	(2402 - 2472 @ 40), (30)
-- 
2.1.0


