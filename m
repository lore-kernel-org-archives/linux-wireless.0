Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:45067 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752469AbdKGX7s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Nov 2017 18:59:48 -0500
Received: by mail-pl0-f68.google.com with SMTP id 30so98064pla.2
        for <linux-wireless@vger.kernel.org>; Tue, 07 Nov 2017 15:59:48 -0800 (PST)
From: Ryan Mounce <ryan@mounce.com.au>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        Ryan Mounce <ryan@mounce.com.au>
Subject: [RFC] wireless-regdb: apply 5.8GHz SRD rules to EU/EEA countries (ETSI EN 300 440)
Date: Wed,  8 Nov 2017 10:29:22 +1030
Message-Id: <20171107235922.43180-1-ryan@mounce.com.au> (sfid-20171108_010026_712055_9A99A4D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

EN 300 440 is a harmonised standard applicable in all EU and EEA countries.

https://ec.europa.eu/growth/single-market/european-standards/harmonised-standards/red_en

Signed-off-by: Ryan Mounce <ryan@mounce.com.au>
---
 db.txt | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/db.txt b/db.txt
index 10c84ee..ee24749 100644
--- a/db.txt
+++ b/db.txt
@@ -82,6 +82,8 @@ country AT: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -134,6 +136,8 @@ country BE: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -319,6 +323,8 @@ country CY: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -331,6 +337,8 @@ country CZ: DFS-ETSI
 	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW
 	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
 	(5470 - 5725 @ 160), (500 mW), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -376,6 +384,8 @@ country DK: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -411,6 +421,8 @@ country EE: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -447,6 +459,8 @@ country FI: DFS-ETSI
 	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
 	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
 	(5470 - 5725 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -462,6 +476,8 @@ country FR: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -470,6 +486,8 @@ country GB: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -517,6 +535,8 @@ country GR: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -556,6 +576,8 @@ country HR: DFS-ETSI
 	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
 	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
 	(5470 - 5725 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -571,6 +593,8 @@ country HU: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -584,6 +608,8 @@ country IE: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -606,6 +632,8 @@ country IS: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -614,6 +642,8 @@ country IT: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -721,6 +751,8 @@ country LI: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 
 country LK: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -742,6 +774,8 @@ country LT: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -750,6 +784,8 @@ country LU: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -758,6 +794,8 @@ country LV: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -849,6 +887,8 @@ country MT: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -990,6 +1030,8 @@ country PL: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -1011,6 +1053,8 @@ country PT: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -1043,6 +1087,8 @@ country RO: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -1083,6 +1129,8 @@ country SE: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -1103,6 +1151,8 @@ country SI: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
@@ -1111,6 +1161,8 @@ country SK: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
+	# SRD harmonised in EU/EEA (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (14)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-- 
2.13.6 (Apple Git-96)
