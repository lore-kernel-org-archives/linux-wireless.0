Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.tpnet.fi ([62.106.63.33]:41826 "EHLO webmail.tpnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbbKYT1r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 14:27:47 -0500
From: Anssi Hannula <anssi.hannula@iki.fi>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] wireless-regdb: Update regulatory rules for Finland (FI)
Date: Wed, 25 Nov 2015 21:21:28 +0200
Message-Id: <1448479288-27002-1-git-send-email-anssi.hannula@iki.fi> (sfid-20151125_202751_196150_91BD6506)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bands in 5150-5350 MHz are limited to indoor use, and band 5150-5250 MHz
has an increased power limit. The ranges are also slightly expanded to
match the regulation.

Regulatory source (6 Feb 2015), Section 13:
https://www.viestintavirasto.fi/attachments/maaraykset/Viestintavirasto15AH2015_en.pdf

Verified also from the authoritative Finnish version:
https://www.viestintavirasto.fi/attachments/maaraykset/Viestintavirasto15AH2015M.pdf

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
---
 db.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index b04d5e5..a6eb033 100644
--- a/db.txt
+++ b/db.txt
@@ -396,10 +396,10 @@ country ET: DFS-ETSI
 	(5490 - 5710 @ 160), (27), DFS
 
 country FI: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(2400 - 2483.5 @ 40), (20)
+	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
+	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
+	(5470 - 5725 @ 160), (27), DFS
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-- 
2.3.10

