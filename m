Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:39787 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3KAN6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:53 -0400
Received: by mail-we0-f177.google.com with SMTP id x55so3959247wes.22
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:52 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 24/65] wireless-regdb: enable VHT80 for IR
Date: Fri,  1 Nov 2013 14:57:14 +0100
Message-Id: <1383314275-20960-25-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150808_698106_FEA9557B)
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
index 0602a80..accba4b 100644
--- a/db.txt
+++ b/db.txt
@@ -408,7 +408,7 @@ country IS: DFS-ETSI
 
 country IR: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5735 - 5835 @ 40), (30)
+	(5735 - 5835 @ 80), (30)
 
 country IT: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

