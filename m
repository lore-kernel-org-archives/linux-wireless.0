Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:37024 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3KAN6D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:03 -0400
Received: by mail-we0-f178.google.com with SMTP id q59so4067991wes.9
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:01 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 01/65] wireless-regdb: enable HT40  for AL on 2.4 GHz
Date: Fri,  1 Nov 2013 14:56:51 +0100
Message-Id: <1383314275-20960-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145806_924115_63E0E98D)
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
index 11e0cb8..4c22199 100644
--- a/db.txt
+++ b/db.txt
@@ -26,7 +26,7 @@ country AE: DFS-FCC
 	(5735 - 5835 @ 80), (30)
 
 country AL: DFS-ETSI
-	(2402 - 2482 @ 20), (20)
+	(2402 - 2482 @ 40), (20)
 
 country AM: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

