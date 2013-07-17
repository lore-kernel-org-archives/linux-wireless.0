Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37233 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3GQCWS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:22:18 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz11so1415627pad.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:22:18 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 41/53] wireless-regdb: US, United States - enable VHT80
Date: Tue, 16 Jul 2013 19:18:30 -0700
Message-Id: <1374027522-18488-42-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_042222_129592_96EF81BC)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth support on the US 5 GHz
frequencies. This also updates the 5 GHz bands with higher
max EIRP. Note VHT80 for 5690 is disabled.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index 63ee9b4..bc8fe07 100644
--- a/db.txt
+++ b/db.txt
@@ -767,11 +767,11 @@ country UA:
 
 country US: DFS-FCC
 	(2402 - 2472 @ 40), (3, 27)
-	(5170 - 5250 @ 40), (3, 17)
-	(5250 - 5330 @ 40), (3, 20), DFS
-	(5490 - 5600 @ 40), (3, 20), DFS
-	(5650 - 5710 @ 40), (3, 20), DFS
-	(5735 - 5835 @ 40), (3, 30)
+	(5170 - 5250 @ 80), (3, 17)
+	(5250 - 5330 @ 80), (3, 24), DFS
+	(5490 - 5600 @ 80), (3, 24), DFS
+	(5650 - 5710 @ 40), (3, 24), DFS
+	(5735 - 5835 @ 80), (3, 30)
 	# 60g band
 	# reference: http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
 	# channels 1,2,3, EIRP=40dBm(43dBm peak)
-- 
1.7.10.4

