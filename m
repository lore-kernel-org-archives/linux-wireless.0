Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:59346 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab3GDBFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:05:35 -0400
Received: by mail-pb0-f48.google.com with SMTP id ma3so663910pbc.21
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:05:34 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 09/53] wireless-regdb: MX, Mexico - enable VHT80
Date: Wed,  3 Jul 2013 18:04:05 -0700
Message-Id: <1372899889-19183-10-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_030540_512169_8961F9FE)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
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

