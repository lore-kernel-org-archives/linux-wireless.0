Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:43906 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3KAOAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:00:19 -0400
Received: by mail-we0-f176.google.com with SMTP id w62so3935083wes.7
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:00:18 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 59/65] wireless-regdb: extend 5 GHz range for NZ
Date: Fri,  1 Nov 2013 14:57:49 +0100
Message-Id: <1383314275-20960-60-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150808_546034_833E5A2C)
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
index 61df4fc..b1d8115 100644
--- a/db.txt
+++ b/db.txt
@@ -592,7 +592,7 @@ country NZ: DFS-FCC
 	(2402 - 2482 @ 40), (30)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5710 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
 country OM: DFS-ETSI
-- 
1.8.4.rc3

