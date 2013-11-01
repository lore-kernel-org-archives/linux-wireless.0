Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:46808 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3KAN7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:33 -0400
Received: by mail-we0-f175.google.com with SMTP id t61so4063548wes.34
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:32 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 42/65] wireless-regdb: enable VHT80 for GT
Date: Fri,  1 Nov 2013 14:57:32 +0100
Message-Id: <1383314275-20960-43-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150811_711071_4A249471)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also increase the 2.4 GHz max EIRP.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 26c5900..0c9dc2c 100644
--- a/db.txt
+++ b/db.txt
@@ -327,10 +327,10 @@ country GL: DFS-ETSI
 	(5490 - 5710 @ 80), (27), DFS
 
 country GT: DFS-FCC
-	(2402 - 2472 @ 40), (27)
-	(5170 - 5250 @ 40), (17)
-	(5250 - 5330 @ 40), (23), DFS
-	(5735 - 5835 @ 40), (30)
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
 
 country GU: DFS-FCC
 	(2402 - 2472 @ 40), (27)
-- 
1.8.4.rc3

