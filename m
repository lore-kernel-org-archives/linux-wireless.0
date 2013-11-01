Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:54205 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3KAN6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:24 -0400
Received: by mail-we0-f182.google.com with SMTP id t61so3943988wes.41
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:24 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 11/65] wireless-regdb: enable VHT80 for BZ
Date: Fri,  1 Nov 2013 14:57:01 +0100
Message-Id: <1383314275-20960-12-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150808_938330_DC222DB4)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 5bdb532..51841a2 100644
--- a/db.txt
+++ b/db.txt
@@ -141,7 +141,7 @@ country BY: DFS-ETSI
 
 country BZ: DFS-JP
 	(2402 - 2482 @ 40), (30)
-	(5735 - 5835 @ 40), (30)
+	(5735 - 5835 @ 80), (30)
 
 country CA: DFS-FCC
 	(2402 - 2472 @ 40), (27)
-- 
1.8.4.rc3

