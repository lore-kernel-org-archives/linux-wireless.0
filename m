Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60125 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab3GDBIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:08:04 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz11so772755pad.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:08:04 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 43/53] wireless-regdb: IL, Isreal - enable VHT80
Date: Wed,  3 Jul 2013 18:04:39 -0700
Message-Id: <1372899889-19183-44-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_032042_108436_8231633F)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage on 5 GHz.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index a101b1e..a4d0587 100644
--- a/db.txt
+++ b/db.txt
@@ -394,8 +394,8 @@ country IE: DFS-ETSI
 
 country IL:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
-	(5250 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
+	(5150 - 5250 @ 80), (N/A, 200 mW), NO-OUTDOOR
+	(5250 - 5350 @ 80), (N/A, 200 mW), NO-OUTDOOR, DFS
 
 country IN:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

