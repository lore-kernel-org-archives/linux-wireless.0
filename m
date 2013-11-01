Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38295 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3KAN6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:21 -0400
Received: by mail-wi0-f173.google.com with SMTP id ey11so1118137wid.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:19 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 09/65] wireless-regdb: enable VHT80 for BO
Date: Fri,  1 Nov 2013 14:56:59 +0100
Message-Id: <1383314275-20960-10-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150812_374707_863A8FA1)
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
index ef0a155..572d34f 100644
--- a/db.txt
+++ b/db.txt
@@ -124,7 +124,7 @@ country BN: DFS-JP
 
 country BO: DFS-JP
 	(2402 - 2482 @ 40), (30)
-	(5735 - 5835 @ 40), (30)
+	(5735 - 5835 @ 80), (30)
 
 country BR: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

