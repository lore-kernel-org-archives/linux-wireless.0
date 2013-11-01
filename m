Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43369 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3KAN66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:58 -0400
Received: by mail-wi0-f180.google.com with SMTP id ey11so1108268wid.7
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:57 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 26/65] wireless-regdb: enable VHT80 for JO
Date: Fri,  1 Nov 2013 14:57:16 +0100
Message-Id: <1383314275-20960-27-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150811_985276_1D943F0A)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This also adds a new 5 GHz frequency range for JO,
as well as increase the max EIRP on the existing 5 GHz
frequency range from 18 dBm to 23 dBm.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 1d8c0b5..ed3edc4 100644
--- a/db.txt
+++ b/db.txt
@@ -436,7 +436,8 @@ country JP: DFS-JP
 
 country JO: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (18)
+	(5170 - 5250 @ 80), (23)
+	(5735 - 5835 @ 80), (23)
 
 country KE: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

