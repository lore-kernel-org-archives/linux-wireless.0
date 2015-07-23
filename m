Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:36141 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbGWDdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 23:33:12 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: seth.forshee@canonical.com
Cc: Chen-Yu Tsai <wens@csie.org>, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 4/5] wireless-regdb: Update 5GHz rules for US
Date: Thu, 23 Jul 2015 11:32:59 +0800
Message-Id: <1437622380-4154-5-git-send-email-wens@csie.org> (sfid-20150723_053323_241635_62C03332)
In-Reply-To: <1437622380-4154-1-git-send-email-wens@csie.org>
References: <1437622380-4154-1-git-send-email-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FCC increased the maximum conducted transmission power for the
U-NII-1 (5150 ~ 5250 MHz) band to 30 dBm or 1 W for master devices
and 24 dBm or 250 mW for mobile/portable devices.

Effective 6/2/2014.

See FCC KDB 905462 D06.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 db.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index cadd52c..29ba4b6 100644
--- a/db.txt
+++ b/db.txt
@@ -1160,7 +1160,7 @@ country UG: DFS-FCC
 
 country US: DFS-FCC
 	(2402 - 2472 @ 40), (30)
-	(5170 - 5250 @ 80), (17), AUTO-BW
+	(5170 - 5250 @ 80), (30), AUTO-BW
 	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
 	(5490 - 5730 @ 160), (23), DFS
 	(5735 - 5835 @ 80), (30)
-- 
2.1.4

