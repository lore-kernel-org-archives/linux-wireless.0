Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60315 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477Ab3GDBHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:07:46 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl14so764487pab.20
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:07:46 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 39/53] wireless-regdb: CN, China - enable VHT80
Date: Wed,  3 Jul 2013 18:04:35 -0700
Message-Id: <1372899889-19183-40-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_032039_280813_533875C2)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
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

