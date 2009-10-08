Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:23069 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759656AbZJHS6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:34 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 11/20] wl1271: added Juuso Oikarinen as module author
Date: Thu,  8 Oct 2009 21:56:27 +0300
Message-Id: <1255028196-6565-12-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add Juuso as one of the module authors, since he's working heavily on this
module as well.

Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 0a0f2ea..1a0491a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1449,3 +1449,4 @@ module_exit(wl1271_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-- 
1.5.6.5

