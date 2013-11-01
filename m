Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61396 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab3KAN7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:24 -0400
Received: by mail-wi0-f170.google.com with SMTP id ex4so1196290wid.3
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:23 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 38/65] wireless-regdb: enable VHT80 for SV
Date: Fri,  1 Nov 2013 14:57:28 +0100
Message-Id: <1383314275-20960-39-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150813_015631_6611AE90)
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
index b64d7a7..c35d06d 100644
--- a/db.txt
+++ b/db.txt
@@ -715,9 +715,9 @@ country SK: DFS-ETSI
 
 country SV: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 20), (17)
-	(5250 - 5330 @ 20), (23), DFS
-	(5735 - 5835 @ 20), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
 
 country SY:
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

