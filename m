Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62756 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3KAN61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:27 -0400
Received: by mail-wi0-f171.google.com with SMTP id f4so1110284wiw.4
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:26 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 12/65] wireless-regdb: enable VHT80 for CL
Date: Fri,  1 Nov 2013 14:57:02 +0100
Message-Id: <1383314275-20960-13-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150813_285536_2B41C188)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index 51841a2..552c95a 100644
--- a/db.txt
+++ b/db.txt
@@ -160,9 +160,9 @@ country CH: DFS-ETSI
 
 country CL: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (20)
-	(5250 - 5330 @ 40), (20), DFS
-	(5735 - 5835 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
 
 country CN: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

