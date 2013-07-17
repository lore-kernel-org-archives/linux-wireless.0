Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44793 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3GQCWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:22:38 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx10so1423018pab.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:22:37 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 45/53] wireless-regdb: MY, Malaysia - enable VHT80
Date: Tue, 16 Jul 2013 19:18:34 -0700
Message-Id: <1374027522-18488-46-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_042240_722610_3D330F74)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
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
index acb9358..c626a48 100644
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

