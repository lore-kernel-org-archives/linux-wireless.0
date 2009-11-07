Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37914 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317AbZKGWBx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 17:01:53 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 22:01:55 +0000
Message-ID: <1257631315.15927.470.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 54/75] prism54: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/prism54/islpci_dev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 2505be5..a3ba353 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -41,6 +41,9 @@
 #define ISL3877_IMAGE_FILE	"isl3877"
 #define ISL3886_IMAGE_FILE	"isl3886"
 #define ISL3890_IMAGE_FILE	"isl3890"
+MODULE_FIRMWARE(ISL3877_IMAGE_FILE);
+MODULE_FIRMWARE(ISL3886_IMAGE_FILE);
+MODULE_FIRMWARE(ISL3890_IMAGE_FILE);
 
 static int prism54_bring_down(islpci_private *);
 static int islpci_alloc_memory(islpci_private *);
-- 
1.6.5.2



