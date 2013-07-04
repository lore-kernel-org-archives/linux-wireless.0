Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46302 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab3GDBI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:08:27 -0400
Received: by mail-pa0-f44.google.com with SMTP id lj1so775224pab.17
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:08:26 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 48/53] wireless-regdb: KR, Republic of Korea - enable VHT80
Date: Wed,  3 Jul 2013 18:04:44 -0700
Message-Id: <1372899889-19183-49-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_032042_339680_19112746)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage for 5 GHz.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 330ccb2..9765ad8 100644
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

