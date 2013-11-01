Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:58131 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3KAN6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:49 -0400
Received: by mail-we0-f182.google.com with SMTP id t61so4045734wes.13
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:48 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 22/65] wireless-regdb: enable VHT80 for IN
Date: Fri,  1 Nov 2013 14:57:12 +0100
Message-Id: <1383314275-20960-23-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150807_519976_17887DA8)
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
index ec9abb2..1b03d74 100644
--- a/db.txt
+++ b/db.txt
@@ -394,9 +394,9 @@ country IL: DFS-ETSI
 
 country IN: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (20)
-	(5250 - 5330 @ 40), (20), DFS
-	(5735 - 5835 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
 
 country IS: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

