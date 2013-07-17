Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47396 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3GQCUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:20:25 -0400
Received: by mail-pb0-f43.google.com with SMTP id md12so1341936pbc.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:20:24 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 18/53] wireless-regdb: VN, Vietnam - enable VHT80
Date: Tue, 16 Jul 2013 19:18:07 -0700
Message-Id: <1374027522-18488-19-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_043609_341466_34C5BFB5)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage on all 5 GHz
frequencies and update the max EIRP. This also adds
two new 5 GHz bands:

  * 5490 - 5710 MHz
  * 5735 - 5835 MHz

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index f714982..47bfc95 100644
--- a/db.txt
+++ b/db.txt
@@ -796,8 +796,10 @@ country VE:
 
 country VN:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(5170 - 5250 @ 80), (3, 17)
+	(5250 - 5330 @ 80), (3, 24), DFS
+	(5490 - 5710 @ 80), (3, 24), DFS
+	(5735 - 5835 @ 80), (3, 30)
 
 country YE:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

