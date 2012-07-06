Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab2GFT7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:42 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 17/33] NFC: Add netlink module alias for NFC
Date: Fri,  6 Jul 2012 22:09:37 +0200
Message-Id: <1341605393-32056-18-git-send-email-sameo@linux.intel.com> (sfid-20120706_220538_150639_545B6F6E)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 8382fbc..ff74979 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -29,6 +29,8 @@
 #include <linux/slab.h>
 #include <linux/nfc.h>
 
+#include <net/genetlink.h>
+
 #include "nfc.h"
 
 #define VERSION "0.1"
@@ -925,3 +927,4 @@ MODULE_DESCRIPTION("NFC Core ver " VERSION);
 MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_NFC);
+MODULE_ALIAS_GENL_FAMILY(NFC_GENL_NAME);
-- 
1.7.10

