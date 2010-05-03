Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:4777 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755605Ab0ECUnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 16:43:19 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 1/4] rt2x00: Remove rt2x00pci.h include from rt2800lib.
Date: Mon,  3 May 2010 22:43:02 +0200
Message-Id: <1272919385-18004-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1272919385-18004-1-git-send-email-gwingerde@gmail.com>
References: <1272919385-18004-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCI specific code has been remove quite some time ago.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 674609d..7310f34 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -40,9 +40,6 @@
 #if defined(CONFIG_RT2X00_LIB_USB) || defined(CONFIG_RT2X00_LIB_USB_MODULE)
 #include "rt2x00usb.h"
 #endif
-#if defined(CONFIG_RT2X00_LIB_PCI) || defined(CONFIG_RT2X00_LIB_PCI_MODULE)
-#include "rt2x00pci.h"
-#endif
 #include "rt2800lib.h"
 #include "rt2800.h"
 #include "rt2800usb.h"
-- 
1.7.1

