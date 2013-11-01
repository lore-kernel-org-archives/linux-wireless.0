Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56751 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3KAOAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:00:34 -0400
Received: by mail-wi0-f172.google.com with SMTP id ez12so1107171wid.17
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:00:33 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 65/65] wireless-regdb: increase 5   GHz power for IL
Date: Fri,  1 Nov 2013 14:57:55 +0100
Message-Id: <1383314275-20960-66-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150813_158702_40695673)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This increases the max EIRP for the only 5 GHz frequency
range on IL from 20 dBm to 23 dBm.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 7ec31a1..591bdab 100644
--- a/db.txt
+++ b/db.txt
@@ -387,7 +387,7 @@ country HU: DFS-ETSI
 country ID: DFS-JP
 	# ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf
 	(2402 - 2482 @ 40), (20)
-	(5735 - 5815 @ 80), (20)
+	(5735 - 5815 @ 80), (23)
 
 country IE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

