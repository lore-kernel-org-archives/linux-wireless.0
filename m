Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56873 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3KAOAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:00:16 -0400
Received: by mail-wi0-f176.google.com with SMTP id ex4so1115436wid.3
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:00:15 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 58/65] wireless-regdb: extend 5 GHz range for GU
Date: Fri,  1 Nov 2013 14:57:48 +0100
Message-Id: <1383314275-20960-59-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150808_812199_F49FD4BF)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also increase the 2.4 GHz max EIRP.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 1131900..61df4fc 100644
--- a/db.txt
+++ b/db.txt
@@ -342,10 +342,10 @@ country GT: DFS-FCC
 	(5735 - 5835 @ 80), (30)
 
 country GU: DFS-FCC
-	(2402 - 2472 @ 40), (27)
+	(2402 - 2472 @ 40), (30)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5710 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
 country HN: DFS-FCC
-- 
1.8.4.rc3

