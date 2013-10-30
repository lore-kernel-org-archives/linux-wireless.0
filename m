Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52798 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3J3Vp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 17:45:28 -0400
Received: by mail-wi0-f176.google.com with SMTP id ex4so5103004wid.9
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 14:45:27 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 6/7] wireless-regdb: optimize two of IL's rules
Date: Wed, 30 Oct 2013 22:45:08 +0100
Message-Id: <1383169509-22619-7-git-send-email-mcgrof@do-not-panic.com> (sfid-20131030_224532_609913_455B9AF4)
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
index 7532166..efd9902 100644
--- a/db.txt
+++ b/db.txt
@@ -389,8 +389,7 @@ country IE: DFS-ETSI
 
 country IL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR
-	(5250 - 5350 @ 80), (200 mW), NO-OUTDOOR
+	(5150 - 5350 @ 80), (200 mW), NO-OUTDOOR
 
 country IN: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

