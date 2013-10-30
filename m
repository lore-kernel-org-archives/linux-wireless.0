Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50541 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3J3VpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 17:45:22 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so1953812wgh.5
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 14:45:21 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 4/7] wireless-regdb: optimize two of DE's rules
Date: Wed, 30 Oct 2013 22:45:06 +0100
Message-Id: <1383169509-22619-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20131030_224529_335126_9CDB616C)
In-Reply-To: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no reason not to merge these two rules.
This as picked up by the new CRDA optimizer.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 5ca9704..da8fcfe 100644
--- a/db.txt
+++ b/db.txt
@@ -222,10 +222,8 @@ country CZ: DFS-ETSI
 country DE: DFS-ETSI
 	# entries 279004 and 280006
 	(2400 - 2483.5 @ 40), (100 mW)
-	# entry 303005
-	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR
-	# entries 304002 and 305002
-	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR
+	# entry 303005, 304002 and 305002
+	(5150 - 5350 @ 80), (100 mW), NO-OUTDOOR
 	# entries 308002, 309001 and 310003
 	(5470 - 5725 @ 80), (500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-- 
1.8.4.rc3

