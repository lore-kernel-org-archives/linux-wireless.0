Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:64072 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab3KAN6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:42 -0400
Received: by mail-wg0-f41.google.com with SMTP id b13so1065000wgh.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:42 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 19/65] wireless-regdb: enable VHT80 for HT
Date: Fri,  1 Nov 2013 14:57:09 +0100
Message-Id: <1383314275-20960-20-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150811_091395_4D0819AC)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index 9f2fd2a..88dd152 100644
--- a/db.txt
+++ b/db.txt
@@ -363,9 +363,9 @@ country HR: DFS-ETSI
 
 country HT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (20)
-	(5250 - 5330 @ 40), (20), DFS
-	(5490 - 5710 @ 40), (27), DFS
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 
 country HU: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

