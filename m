Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36778 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3GQCTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:19:40 -0400
Received: by mail-pa0-f51.google.com with SMTP id lf11so1428995pab.10
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:19:40 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 10/53] wireless-regdb: PE, Peru - enable VHT80
Date: Tue, 16 Jul 2013 19:17:59 -0700
Message-Id: <1374027522-18488-11-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_043608_205999_9B95A622)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage the existing only
5 GHz band but also adds 3 other new 5 GHz bands with
80 MHz bandwidth support.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 570a951..00e5993 100644
--- a/db.txt
+++ b/db.txt
@@ -597,7 +597,10 @@ country PA:
 
 country PE:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5735 - 5835 @ 40), (N/A, 30)
+	(5170 - 5250 @ 80), (3, 17)
+	(5250 - 5330 @ 80), (3, 24), DFS
+	(5490 - 5710 @ 80), (3, 24), DFS
+	(5735 - 5835 @ 80), (3, 30)
 
 country PG:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

