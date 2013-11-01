Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60306 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3KAOAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:00:10 -0400
Received: by mail-we0-f174.google.com with SMTP id u56so4032301wes.33
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:00:09 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 57/65] wireless-regdb: extend 5 GHz range for EC
Date: Fri,  1 Nov 2013 14:57:47 +0100
Message-Id: <1383314275-20960-58-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150016_917529_1751A3AE)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends the 5 GHz DFS frequency range.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 3eb782c..1131900 100644
--- a/db.txt
+++ b/db.txt
@@ -259,7 +259,7 @@ country EC: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5710 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
 country EE: DFS-ETSI
-- 
1.8.4.rc3

