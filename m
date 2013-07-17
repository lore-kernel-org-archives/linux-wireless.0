Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42989 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3GQCWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:22:09 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so1296267pdj.36
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:22:08 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 39/53] wireless-regdb: CN, China - enable VHT80
Date: Tue, 16 Jul 2013 19:18:28 -0700
Message-Id: <1374027522-18488-40-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_042213_458662_8351E594)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enable 80 MHz on the 5 GHz band.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 4f2d4e7..ead6646 100644
--- a/db.txt
+++ b/db.txt
@@ -164,7 +164,7 @@ country CL:
 
 country CN:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5735 - 5835 @ 40), (N/A, 30)
+	(5735 - 5835 @ 80), (N/A, 30)
 	# 60 gHz band channels 1,4: 28dBm, channels 2,3: 44dBm
 	# ref: http://www.miit.gov.cn/n11293472/n11505629/n11506593/n11960250/n11960606/n11960700/n12330791.files/n12330790.pdf
 	(57240 - 59400 @ 2160), (N/A, 28)
-- 
1.7.10.4

