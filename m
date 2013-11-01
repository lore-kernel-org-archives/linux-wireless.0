Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43812 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab3KAN7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:17 -0400
Received: by mail-wi0-f170.google.com with SMTP id ex4so1196399wid.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:16 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 35/65] wireless-regdb: enable VHT80 for QA
Date: Fri,  1 Nov 2013 14:57:25 +0100
Message-Id: <1383314275-20960-36-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150812_738261_CA3F43D4)
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
index ecdec07..4483b74 100644
--- a/db.txt
+++ b/db.txt
@@ -645,7 +645,7 @@ country PR: DFS-FCC
 
 country QA: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5735 - 5835 @ 40), (30)
+	(5735 - 5835 @ 80), (30)
 
 country RO: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

