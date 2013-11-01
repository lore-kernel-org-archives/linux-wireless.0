Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57267 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3KAN6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:04 -0400
Received: by mail-wg0-f44.google.com with SMTP id n12so4068708wgh.35
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:03 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 02/65] wireless-regdb: enable VHT80 for AM
Date: Fri,  1 Nov 2013 14:56:52 +0100
Message-Id: <1383314275-20960-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145809_376016_98CB0F6A)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 4c22199..d08281f 100644
--- a/db.txt
+++ b/db.txt
@@ -30,8 +30,8 @@ country AL: DFS-ETSI
 
 country AM: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 20), (18)
-	(5250 - 5330 @ 20), (18), DFS
+	(5170 - 5250 @ 80), (18)
+	(5250 - 5330 @ 80), (18), DFS
 
 country AN: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

