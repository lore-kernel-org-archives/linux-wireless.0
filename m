Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:54616 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAOEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:07 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so4045563wes.32
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:04:06 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 15/23] wireless-regdb: update BG's regulatory rules
Date: Fri,  1 Nov 2013 15:03:10 +0100
Message-Id: <1383314598-21240-16-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150809_383185_FD74EC03)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reduces the 5 GHz max EIRP to 20, enables VHT80
and removes the last 5 GHz DFS frequency range.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index de2e94e..f26fd1d 100644
--- a/db.txt
+++ b/db.txt
@@ -103,8 +103,8 @@ country BE: DFS-ETSI
 
 country BG: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (23)
-	(5250 - 5290 @ 40), (23), DFS
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 40), (30), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
-- 
1.8.4.rc3

