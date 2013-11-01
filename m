Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:52250 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3KAN7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:43 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so3971736wes.18
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:42 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 46/65] wireless-regdb: add VHT80 rules for AL
Date: Fri,  1 Nov 2013 14:57:36 +0100
Message-Id: <1383314275-20960-47-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150001_856233_FA51FB64)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/db.txt b/db.txt
index 50307eb..68e896c 100644
--- a/db.txt
+++ b/db.txt
@@ -27,6 +27,9 @@ country AE: DFS-FCC
 
 country AL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20.00)
+	(5250 - 5330 @ 80), (20.00), DFS
+	(5490 - 5710 @ 80), (27.00), DFS
 
 country AM: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

