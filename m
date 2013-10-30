Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39433 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3J3Vp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 17:45:27 -0400
Received: by mail-wi0-f171.google.com with SMTP id f4so3537856wiw.10
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 14:45:25 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 5/7] wireless-regdb: optimize two of ES's rules
Date: Wed, 30 Oct 2013 22:45:07 +0100
Message-Id: <1383169509-22619-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131030_224531_220799_C8EAC12A)
In-Reply-To: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no reason not to merge these two rules.
This as picked up by the new CRDA optimizer.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index da8fcfe..7532166 100644
--- a/db.txt
+++ b/db.txt
@@ -268,8 +268,7 @@ country EG: DFS-ETSI
 
 country ES: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR
-	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR
+	(5150 - 5350 @ 80), (100 mW), NO-OUTDOOR 
 	(5470 - 5725 @ 80), (500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
-- 
1.8.4.rc3

