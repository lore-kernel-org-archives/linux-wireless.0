Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63173 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3GQCTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:19:35 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro2so1354393pbb.27
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:19:34 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 09/53] wireless-regdb: MX, Mexico - enable VHT80
Date: Tue, 16 Jul 2013 19:17:58 -0700
Message-Id: <1374027522-18488-10-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_041937_568686_E7827730)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage on all 5 GHz
frequencies and update the max EIRP. This also adds
a new DFS 5 GHz band: 5490 - 5710 MHz.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index 4b1cf8e..570a951 100644
--- a/db.txt
+++ b/db.txt
@@ -550,9 +550,10 @@ country MY:
 
 country MX:
 	(2402 - 2472 @ 40), (3, 27)
-	(5170 - 5250 @ 40), (3, 17)
-	(5250 - 5330 @ 40), (3, 23), DFS
-	(5735 - 5835 @ 40), (3, 30)
+	(5170 - 5250 @ 80), (3, 17)
+	(5250 - 5330 @ 80), (3, 24), DFS
+	(5490 - 5710 @ 80), (3, 24), DFS
+	(5735 - 5835 @ 80), (3, 30)
 
 country NL: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

