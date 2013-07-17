Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37461 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3GQCWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:22:53 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp16so1358896pbb.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:22:52 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 48/53] wireless-regdb: KR, Republic of Korea - enable VHT80
Date: Tue, 16 Jul 2013 19:18:37 -0700
Message-Id: <1374027522-18488-49-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_042255_858868_E3B25FBB)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage for 5 GHz.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 0815e6e..530c687 100644
--- a/db.txt
+++ b/db.txt
@@ -462,10 +462,10 @@ country KP:
 
 country KR:
 	(2402 - 2482 @ 20), (N/A, 20)
-	(5170 - 5250 @ 20), (3, 20)
-	(5250 - 5330 @ 20), (3, 20), DFS
-	(5490 - 5630 @ 20), (3, 30), DFS
-	(5735 - 5815 @ 20), (3, 30)
+	(5170 - 5250 @ 80), (3, 20)
+	(5250 - 5330 @ 80), (3, 20), DFS
+	(5490 - 5630 @ 80), (3, 30), DFS
+	(5735 - 5815 @ 80), (3, 30)
 
 country KW:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

