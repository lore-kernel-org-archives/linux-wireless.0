Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:56851 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab3GDBIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:08:31 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so587997pdj.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:08:30 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 49/53] wireless-regdb: TW, Taiwan - enable VHT80
Date: Wed,  3 Jul 2013 18:04:45 -0700
Message-Id: <1372899889-19183-50-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_032043_222271_7A69EDC9)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage and enables a new
5 GHz band:

  * 5490 - 5710 MHz

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 9765ad8..7b1e6e8 100644
--- a/db.txt
+++ b/db.txt
@@ -729,8 +729,9 @@ country SY:
 
 country TW:
 	(2402 - 2472 @ 40), (3, 27)
-	(5270 - 5330 @ 40), (3, 17), DFS
-	(5735 - 5815 @ 40), (3, 30)
+	(5270 - 5330 @ 80), (3, 17), DFS
+	(5490 - 5710 @ 80), (3, 30), DFS
+	(5735 - 5815 @ 80), (3, 30)
 
 country TH:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

