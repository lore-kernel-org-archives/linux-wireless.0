Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:41391 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab3GDBIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:08:14 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro2so668025pbb.13
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:08:13 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 45/53] wireless-regdb: MY, Malaysia - enable VHT80
Date: Wed,  3 Jul 2013 18:04:41 -0700
Message-Id: <1372899889-19183-46-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_032044_050374_ECE4B0C7)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage on 5 GHz, updates the
max EIRP and adds a new 5 GHz range:

  * 5170 - 5250 MHz

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 16d9f8c..fa8502c 100644
--- a/db.txt
+++ b/db.txt
@@ -548,8 +548,9 @@ country MT: DFS-ETSI
 
 country MY:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 30), DFS
-	(5735 - 5835 @ 40), (N/A, 30)
+	(5170 - 5250 @ 80), (N/A, 17)
+	(5250 - 5330 @ 80), (N/A, 23), DFS
+	(5735 - 5835 @ 80), (N/A, 30)
 
 country MX:
 	(2402 - 2472 @ 40), (3, 27)
-- 
1.7.10.4

