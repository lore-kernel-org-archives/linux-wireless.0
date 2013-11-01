Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:46637 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3KAN6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:11 -0400
Received: by mail-we0-f179.google.com with SMTP id w61so3914080wes.24
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:10 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 05/65] wireless-regdb: enable VHT80 for AZ
Date: Fri,  1 Nov 2013 14:56:55 +0100
Message-Id: <1383314275-20960-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145817_195248_94A9CC40)
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
index 993b8f1..2f62549 100644
--- a/db.txt
+++ b/db.txt
@@ -69,8 +69,8 @@ country AW: DFS-ETSI
 
 country AZ: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (18)
-	(5250 - 5330 @ 40), (18), DFS
+	(5170 - 5250 @ 80), (18)
+	(5250 - 5330 @ 80), (18), DFS
 
 country BA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

