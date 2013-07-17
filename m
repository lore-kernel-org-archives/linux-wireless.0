Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44318 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3GQCW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:22:57 -0400
Received: by mail-pb0-f43.google.com with SMTP id md12so1347021pbc.16
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:22:57 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 49/53] wireless-regdb: TW, Taiwan - enable VHT80
Date: Tue, 16 Jul 2013 19:18:38 -0700
Message-Id: <1374027522-18488-50-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_042300_173076_8BAB5838)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage and enables a new
5 GHz band:

  * 5490 - 5710 MHz

Note VHT80 for 5290 is not enabled as its use would require
usage of two bands with different parameters.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 530c687..0a4b56f 100644
--- a/db.txt
+++ b/db.txt
@@ -730,7 +730,8 @@ country SY:
 country TW:
 	(2402 - 2472 @ 40), (3, 27)
 	(5270 - 5330 @ 40), (3, 17), DFS
-	(5735 - 5815 @ 40), (3, 30)
+	(5490 - 5710 @ 80), (3, 30), DFS
+	(5735 - 5815 @ 80), (3, 30)
 
 country TH:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

