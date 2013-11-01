Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54205 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3KAN7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:04 -0400
Received: by mail-we0-f174.google.com with SMTP id u56so3959084wes.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:03 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 29/65] wireless-regdb: enable VHT80 for LT
Date: Fri,  1 Nov 2013 14:57:19 +0100
Message-Id: <1383314275-20960-30-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145909_906946_3CDD06C1)
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
index 00029d9..c84624f 100644
--- a/db.txt
+++ b/db.txt
@@ -490,9 +490,9 @@ country LK: DFS-FCC
 
 country LT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (20)
-	(5250 - 5330 @ 40), (20), DFS
-	(5490 - 5710 @ 40), (27), DFS
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-- 
1.8.4.rc3

