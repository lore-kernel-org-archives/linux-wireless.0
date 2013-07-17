Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:42424 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3GQCUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:20:13 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp16so1356848pbb.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:20:12 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 16/53] wireless-regdb: TH, Thailand - enable VHT80
Date: Tue, 16 Jul 2013 19:18:05 -0700
Message-Id: <1374027522-18488-17-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_043609_093790_0B9B8A89)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage on all 5 GHz
frequencies and update the max EIRP.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 4475019..84214b0 100644
--- a/db.txt
+++ b/db.txt
@@ -726,10 +726,10 @@ country TW:
 
 country TH:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (3, 17)
-	(5250 - 5330 @ 40), (3, 20), DFS
-	(5490 - 5710 @ 40), (3, 20), DFS
-	(5735 - 5835 @ 40), (3, 30)
+	(5170 - 5250 @ 80), (3, 17)
+	(5250 - 5330 @ 80), (3, 24), DFS
+	(5490 - 5710 @ 80), (3, 24), DFS
+	(5735 - 5835 @ 80), (3, 30)
 
 country TT:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

