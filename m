Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37909 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbZKGWBi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 17:01:38 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: John Linville <linville@tuxdriver.com>
Cc: Pavel Roskin <proski@gnu.org>,
	David Gibson <hermes@gibson.dropbear.id.au>,
	linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 22:01:29 +0000
Message-ID: <1257631289.15927.467.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 53/75] orinoco: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/orinoco/fw.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
index 1257250..cfa7296 100644
--- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -28,6 +28,12 @@ static const struct fw_info orinoco_fw[] = {
 	{ NULL, "prism_sta_fw.bin", "prism_ap_fw.bin", 0, 1024 },
 	{ "symbol_sp24t_prim_fw", "symbol_sp24t_sec_fw", NULL, 0x00003100, 512 }
 };
+MODULE_FIRMWARE("agere_sta_fw.bin");
+MODULE_FIRMWARE("agere_ap_fw.bin");
+MODULE_FIRMWARE("prism_sta_fw.bin");
+MODULE_FIRMWARE("prism_ap_fw.bin");
+MODULE_FIRMWARE("symbol_sp24t_prim_fw");
+MODULE_FIRMWARE("symbol_sp24t_sec_fw");
 
 /* Structure used to access fields in FW
  * Make sure LE decoding macros are used
-- 
1.6.5.2



