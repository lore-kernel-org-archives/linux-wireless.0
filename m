Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64984 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab3GDBGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:06:14 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj3so777162pad.14
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:06:13 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 18/53] wireless-regdb: VN, Vietnam - enable VHT80
Date: Wed,  3 Jul 2013 18:04:14 -0700
Message-Id: <1372899889-19183-19-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_032043_625177_CF78D60F)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
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

