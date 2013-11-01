Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39704 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab3KAN6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:16 -0400
Received: by mail-wg0-f47.google.com with SMTP id c11so4002968wgh.26
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:15 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 07/65] wireless-regdb: enable VHT80 for BB
Date: Fri,  1 Nov 2013 14:56:57 +0100
Message-Id: <1383314275-20960-8-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145826_578627_256544BD)
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
index 11060e3..f49d8f4 100644
--- a/db.txt
+++ b/db.txt
@@ -82,9 +82,9 @@ country BA: DFS-ETSI
 
 country BB: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (23)
-	(5250 - 5330 @ 40), (23), DFS
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (23)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
 
 country BD: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

