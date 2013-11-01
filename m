Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33157 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab3KAN7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:13 -0400
Received: by mail-wg0-f52.google.com with SMTP id k14so4109747wgh.7
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:12 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 33/65] wireless-regdb: enable VHT80 for KH
Date: Fri,  1 Nov 2013 14:57:23 +0100
Message-Id: <1383314275-20960-34-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145917_714526_B3FD6C62)
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
index 27975b2..186bcb0 100644
--- a/db.txt
+++ b/db.txt
@@ -445,9 +445,9 @@ country KE: DFS-JP
 
 country KH: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (20)
-	(5250 - 5330 @ 40), (20), DFS
-	(5490 - 5710 @ 40), (27), DFS
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 
 country KP: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

