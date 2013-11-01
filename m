Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48847 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3KAN7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:48 -0400
Received: by mail-wg0-f42.google.com with SMTP id n12so1062371wgh.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:47 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 48/65] wireless-regdb: add VHT80 rules for LB
Date: Fri,  1 Nov 2013 14:57:38 +0100
Message-Id: <1383314275-20960-49-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145953_069642_A0B178DE)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index f63565c..551fe14 100644
--- a/db.txt
+++ b/db.txt
@@ -477,7 +477,10 @@ country KZ:
 
 country LB: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
 
 country LI: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

