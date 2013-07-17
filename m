Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45700 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3GQCUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:20:18 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro2so1347620pbb.41
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:20:18 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 17/53] wireless-regdb: AE, United Arab Emirates - enable VHT80
Date: Tue, 16 Jul 2013 19:18:06 -0700
Message-Id: <1374027522-18488-18-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_043607_953619_92C4D235)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage on all 5 GHz
frequencies and update the max EIRP. This also adds
a new DFS 5 GHz band: 5735 - 5835 MHz.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index 84214b0..f714982 100644
--- a/db.txt
+++ b/db.txt
@@ -18,9 +18,10 @@ country AD:
 
 country AE:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 20), DFS
-	(5490 - 5710 @ 40), (N/A, 27), DFS
+	(5170 - 5250 @ 80), (3, 17)
+	(5250 - 5330 @ 80), (3, 24), DFS
+	(5490 - 5710 @ 80), (3, 24), DFS
+	(5735 - 5835 @ 80), (3, 30)
 
 country AL:
 	(2402 - 2482 @ 20), (N/A, 20)
-- 
1.7.10.4

