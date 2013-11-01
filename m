Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61930 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab3KAN6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:18 -0400
Received: by mail-wg0-f52.google.com with SMTP id k14so4108865wgh.7
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:17 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 08/65] wireless-regdb: enable VHT80 for BH
Date: Fri,  1 Nov 2013 14:56:58 +0100
Message-Id: <1383314275-20960-9-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145823_393313_5C67D78D)
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
index f49d8f4..ef0a155 100644
--- a/db.txt
+++ b/db.txt
@@ -107,9 +107,9 @@ country BG: DFS-ETSI
 
 country BH: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 20), (20)
-	(5250 - 5330 @ 20), (20), DFS
-	(5735 - 5835 @ 20), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
 
 country BL:
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

