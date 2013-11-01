Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62828 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3KAN7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:00 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn9so1111807wib.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:59 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 27/65] wireless-regdb: enable VHT80 for LI
Date: Fri,  1 Nov 2013 14:57:17 +0100
Message-Id: <1383314275-20960-28-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145904_940649_DBEDC934)
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
index ed3edc4..3f6753a 100644
--- a/db.txt
+++ b/db.txt
@@ -477,9 +477,9 @@ country LB: DFS-FCC
 
 country LI: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (20)
-	(5250 - 5330 @ 40), (20), DFS
-	(5490 - 5710 @ 40), (27), DFS
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 
 country LK: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

