Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53352 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab0IBNdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 09:33:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat-wireless: fix patch style
Date: Thu,  2 Sep 2010 15:32:57 +0200
Message-Id: <1283434377-26210-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1283434377-26210-1-git-send-email-hauke@hauke-m.de>
References: <1283434377-26210-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/24-pcmcia.patch |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
index 5468645..6324a76 100644
--- a/patches/24-pcmcia.patch
+++ b/patches/24-pcmcia.patch
@@ -133,7 +133,7 @@
 +#else
 +	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
 +	link->io.NumPorts1 = 64;
-+	link->io.IOAddrLines = 6;;
++	link->io.IOAddrLines = 6;
 +#endif
  
  	for (n = 0; n < 0x400; n += 0x40) {
-- 
1.7.0.4

