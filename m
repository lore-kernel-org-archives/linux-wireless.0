Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35734 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab3KAN70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:26 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so4084501wgh.27
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:25 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 39/65] wireless-regdb: enable VHT80 for TN
Date: Fri,  1 Nov 2013 14:57:29 +0100
Message-Id: <1383314275-20960-40-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150810_434240_B0975AB4)
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
index c35d06d..f155d7b 100644
--- a/db.txt
+++ b/db.txt
@@ -744,8 +744,8 @@ country TT: DFS-FCC
 
 country TN: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 20), (20)
-	(5250 - 5330 @ 20), (20), DFS
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
 
 country TR: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

