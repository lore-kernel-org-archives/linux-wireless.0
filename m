Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41828 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1CGOKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 09:10:50 -0500
Received: by eyx24 with SMTP id 24so1407260eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2011 06:10:49 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: trivial: update B43_PHY_N description (PHY support)
Date: Mon,  7 Mar 2011 15:09:19 +0100
Message-Id: <1299506959-8164-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: this is for 2.6.39
---
 drivers/net/wireless/b43/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 47033f6..480595f 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -92,7 +92,7 @@ config B43_PHY_N
 	---help---
 	  Support for the N-PHY.
 
-	  This enables support for devices with N-PHY revision up to 2.
+	  This enables support for devices with N-PHY.
 
 	  Say N if you expect high stability and performance. Saying Y will not
 	  affect other devices support and may provide support for basic needs.
-- 
1.7.1

