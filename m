Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53594 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbZKGV6E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 16:58:04 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: John Linville <linville@tuxdriver.com>
Cc: Simon Kelley <simon@thekelleys.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 21:58:05 +0000
Message-ID: <1257631085.15927.454.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 46/75] atmel: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/atmel.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index cce1888..3edbbcf 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -99,6 +99,22 @@ static struct {
 	{ ATMEL_FW_TYPE_506,		"atmel_at76c506",	"bin" },
 	{ ATMEL_FW_TYPE_NONE,		NULL,			NULL }
 };
+MODULE_FIRMWARE("atmel_at76c502-wpa.bin");
+MODULE_FIRMWARE("atmel_at76c502.bin");
+MODULE_FIRMWARE("atmel_at76c502d-wpa.bin");
+MODULE_FIRMWARE("atmel_at76c502d.bin");
+MODULE_FIRMWARE("atmel_at76c502e-wpa.bin");
+MODULE_FIRMWARE("atmel_at76c502e.bin");
+MODULE_FIRMWARE("atmel_at76c502_3com-wpa.bin");
+MODULE_FIRMWARE("atmel_at76c502_3com.bin");
+MODULE_FIRMWARE("atmel_at76c504-wpa.bin");
+MODULE_FIRMWARE("atmel_at76c504.bin");
+MODULE_FIRMWARE("atmel_at76c504_2958-wpa.bin");
+MODULE_FIRMWARE("atmel_at76c504_2958.bin");
+MODULE_FIRMWARE("atmel_at76c504a_2958-wpa.bin");
+MODULE_FIRMWARE("atmel_at76c504a_2958.bin");
+MODULE_FIRMWARE("atmel_at76c506-wpa.bin");
+MODULE_FIRMWARE("atmel_at76c506.bin");
 
 #define MAX_SSID_LENGTH 32
 #define MGMT_JIFFIES (256 * HZ / 100)
-- 
1.6.5.2



