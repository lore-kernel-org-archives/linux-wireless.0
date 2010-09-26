Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53794 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758Ab0I0R7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:59:07 -0400
Received: by bwz11 with SMTP id 11so3540065bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:59:05 -0700 (PDT)
Message-Id: <424b15c8c817de59402f1dfc3544f5a2cd03ce33.1285544496.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1285544496.git.chunkeey@googlemail.com>
References: <cover.1285544496.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 26 Sep 2010 21:40:40 +0200
Subject: [PATCH 2/6] carl9170: angle brackets for wiki link
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"The convention seems to be angle brackets around
URLS in Kconfig."
 -- Finn Thain (to update web addresses in the kernel)

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index c5d3a3f..2d1b821 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -10,7 +10,7 @@ config CARL9170
 	  but it needs a special firmware (carl9170-1.fw) to do that.
 
 	  The firmware can be downloaded from our wiki here:
-	  http://wireless.kernel.org/en/users/Drivers/carl9170
+	  <http://wireless.kernel.org/en/users/Drivers/carl9170>
 
 	  If you choose to build a module, it'll be called carl9170.
 
-- 
1.7.1

