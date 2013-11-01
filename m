Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:58229 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab3KAN72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:28 -0400
Received: by mail-we0-f181.google.com with SMTP id t60so3965599wes.40
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:27 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 40/65] wireless-regdb: enable VHT80 for NO
Date: Fri,  1 Nov 2013 14:57:30 +0100
Message-Id: <1383314275-20960-41-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150812_236964_8E50A1E8)
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
index f155d7b..db1b850 100644
--- a/db.txt
+++ b/db.txt
@@ -566,9 +566,9 @@ country NL: DFS-ETSI
 
 country NO: DFS-ETSI
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

