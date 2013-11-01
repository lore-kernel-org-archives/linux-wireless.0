Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39123 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3KAP73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 11:59:29 -0400
Received: by mail-wi0-f181.google.com with SMTP id ex4so1274048wid.14
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 08:59:28 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 15/23] wireless-regdb: update BG's regulatory rules
Date: Fri,  1 Nov 2013 16:59:24 +0100
Message-Id: <1383321564-25138-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_165933_748823_F58605A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reduces the 5 GHz max EIRP to 20, enables VHT80
and removes the last 5 GHz DFS frequency range.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---

I had forgotten to remove the 5 GHz frequency range.

 db.txt | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index de2e94e..09a0164 100644
--- a/db.txt
+++ b/db.txt
@@ -103,9 +103,8 @@ country BE: DFS-ETSI
 
 country BG: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (23)
-	(5250 - 5290 @ 40), (23), DFS
-	(5490 - 5710 @ 40), (30), DFS
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-- 
1.8.4.rc3

