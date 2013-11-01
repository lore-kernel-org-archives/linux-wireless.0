Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48020 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab3KAN6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:47 -0400
Received: by mail-wi0-f171.google.com with SMTP id f4so1110734wiw.4
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:46 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 21/65] wireless-regdb: enable VHT80 for GL
Date: Fri,  1 Nov 2013 14:57:11 +0100
Message-Id: <1383314275-20960-22-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150807_175584_AAA47B4D)
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
index cabf2d8..ec9abb2 100644
--- a/db.txt
+++ b/db.txt
@@ -322,9 +322,9 @@ country GR: DFS-ETSI
 
 country GL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 20), (20)
-	(5250 - 5330 @ 20), (20), DFS
-	(5490 - 5710 @ 20), (27), DFS
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 
 country GT: DFS-FCC
 	(2402 - 2472 @ 40), (27)
-- 
1.8.4.rc3

