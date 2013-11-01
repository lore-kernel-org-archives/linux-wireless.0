Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:47332 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3KAN7D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:03 -0400
Received: by mail-we0-f180.google.com with SMTP id q59so4056821wes.11
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:01 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 28/65] wireless-regdb: enable VHT80 for LK
Date: Fri,  1 Nov 2013 14:57:18 +0100
Message-Id: <1383314275-20960-29-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145907_256532_0C0DC458)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables VHT80 for LK but also extends the DFS
frequency range and augments its max EIRP from 20 dbm
to 24 dBm.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 3f6753a..00029d9 100644
--- a/db.txt
+++ b/db.txt
@@ -483,10 +483,10 @@ country LI: DFS-ETSI
 
 country LK: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 20), (17)
-	(5250 - 5330 @ 20), (20), DFS
-	(5490 - 5710 @ 20), (20), DFS
-	(5735 - 5835 @ 20), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
 
 country LT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

