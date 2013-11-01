Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:51661 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3KAN7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:39 -0400
Received: by mail-we0-f176.google.com with SMTP id w62so3961041wes.21
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:38 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 44/65] wireless-regdb: enable VHT80 for VE
Date: Fri,  1 Nov 2013 14:57:34 +0100
Message-Id: <1383314275-20960-45-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145949_706246_333120A7)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds two new 5 GHz frequency ranges with VHT80 support
and extends the existing 5 GHz band by 20 MHz, and enabling
VHT80 support.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index b423b77..cbbbe18 100644
--- a/db.txt
+++ b/db.txt
@@ -796,7 +796,9 @@ country UZ: DFS-FCC
 
 country VE: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5735 - 5815 @ 40), (23)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
 
 country VN: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

