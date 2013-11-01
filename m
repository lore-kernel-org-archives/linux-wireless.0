Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:59153 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3KAN6g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:36 -0400
Received: by mail-we0-f182.google.com with SMTP id t61so3944215wes.41
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:35 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 16/65] wireless-regdb: enable VHT80 for GE
Date: Fri,  1 Nov 2013 14:57:06 +0100
Message-Id: <1383314275-20960-17-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150808_292577_241D5F2C)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index d162eba..2f43aa9 100644
--- a/db.txt
+++ b/db.txt
@@ -292,8 +292,8 @@ country FR: DFS-ETSI
 
 country GE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (18)
-	(5250 - 5330 @ 40), (18), DFS
+	(5170 - 5250 @ 80), (18)
+	(5250 - 5330 @ 80), (18), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-- 
1.8.4.rc3

