Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:52478 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162040Ab3DEQbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 12:31:24 -0400
Message-ID: <1365179481.1830.69.camel@x61.thuisdomein> (sfid-20130405_183142_574547_35FE3F39)
Subject: [PATCH] nfc: Remove useless Makefile line
From: Paul Bolle <pebolle@tiscali.nl>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	linux-kernel@vger.kernel.org
Date: Fri, 05 Apr 2013 18:31:21 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no Kconfig symbol NFC_DEBUG. Besides, there doesn't seem to be
any nfc code that uses a DEBUG macro. This line can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/nfc/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
index a189ada0..5b4ad00 100644
--- a/drivers/nfc/Makefile
+++ b/drivers/nfc/Makefile
@@ -6,5 +6,3 @@ obj-$(CONFIG_NFC_PN544)		+= pn544/
 obj-$(CONFIG_NFC_MICROREAD)	+= microread/
 obj-$(CONFIG_NFC_PN533)		+= pn533.o
 obj-$(CONFIG_NFC_WILINK)	+= nfcwilink.o
-
-ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
-- 
1.7.11.7

