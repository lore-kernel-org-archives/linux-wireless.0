Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61739 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3GQCXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:23:12 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so1354265pbb.22
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:23:12 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 52/53] wireless-regdb: CR, Costa Rica - enable VHT80
Date: Tue, 16 Jul 2013 19:18:41 -0700
Message-Id: <1374027522-18488-53-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_042315_947064_3C295EFB)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage for Costa Rica,
updates the max EIRP and adds a new 5 GHz band:

  * 5490 - 5710

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index 54f89d3..1470772 100644
--- a/db.txt
+++ b/db.txt
@@ -182,9 +182,10 @@ country CO:
 
 country CR:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 20), (3, 17)
-	(5250 - 5330 @ 20), (3, 23), DFS
-	(5735 - 5835 @ 20), (3, 30)
+	(5170 - 5250 @ 80), (3, 17)
+	(5250 - 5330 @ 80), (3, 24), DFS
+	(5490 - 5710 @ 80), (3, 24), DFS
+	(5735 - 5835 @ 80), (3, 30)
 
 country CS:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

