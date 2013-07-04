Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62974 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab3GDBFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:05:00 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl14so771420pab.34
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:04:59 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 01/53] wireless-regdb: AU, Australia - enable VHT80
Date: Wed,  3 Jul 2013 18:03:57 -0700
Message-Id: <1372899889-19183-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_030523_613150_77705FC0)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage on all 5 GHz
frequencies and updates the max EIRP. This also adds
a new DFS 5 GHz band: 5490 - 5710 MHz.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index c5861b8..0e7794e 100644
--- a/db.txt
+++ b/db.txt
@@ -53,9 +53,10 @@ country AT: DFS-ETSI
 
 country AU:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (3, 23)
-	(5250 - 5330 @ 40), (3, 23), DFS
-	(5735 - 5835 @ 40), (3, 30)
+	(5170 - 5250 @ 80), (3, 17)
+	(5250 - 5330 @ 80), (3, 24), DFS
+	(5490 - 5710 @ 80), (3, 24), DFS
+	(5735 - 5835 @ 80), (3, 30)
 
 country AW:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

