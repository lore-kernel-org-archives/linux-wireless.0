Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30702 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0CZKyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:10 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/24] wl1271: fix wl1271_spi driver name
Date: Fri, 26 Mar 2010 12:53:10 +0200
Message-Id: <1269600813-32145-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When forward porting some patches to upstream, there was a mistake and the
wl1271_spi driver name remained, erroneously, as "wl1271".  This patch fixes
that.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index f44b05a..db6c9f5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -442,7 +442,7 @@ static int __devexit wl1271_remove(struct spi_device *spi)
 
 static struct spi_driver wl1271_spi_driver = {
 	.driver = {
-		.name		= "wl1271",
+		.name		= "wl1271_spi",
 		.bus		= &spi_bus_type,
 		.owner		= THIS_MODULE,
 	},
-- 
1.6.3.3

