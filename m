Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51915 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3GQCW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:22:28 -0400
Received: by mail-pb0-f51.google.com with SMTP id um15so1357167pbc.10
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:22:27 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 43/53] wireless-regdb: IL, Isreal - enable VHT80
Date: Tue, 16 Jul 2013 19:18:32 -0700
Message-Id: <1374027522-18488-44-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_042230_971387_2174C626)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage on 5 GHz.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 6aa57a7..0dc6767 100644
--- a/db.txt
+++ b/db.txt
@@ -394,8 +394,8 @@ country IE: DFS-ETSI
 
 country IL:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
-	(5250 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
+	(5150 - 5250 @ 80), (N/A, 200 mW), NO-OUTDOOR
+	(5250 - 5350 @ 80), (N/A, 200 mW), NO-OUTDOOR, DFS
 
 country IN:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

