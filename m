Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0132.outbound.protection.outlook.com ([157.56.112.132]:39729
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754958AbcARN5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 08:57:17 -0500
From: "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"austin.shin@atmel.com" <austin.shin@atmel.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"tony.cho@atmel.com" <tony.cho@atmel.com>,
	"glen.lee@atmel.com" <glen.lee@atmel.com>,
	"leo.kim@atmel.com" <leo.kim@atmel.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] staging: wilc1000: Move Macro definition
Date: Mon, 18 Jan 2016 13:42:35 +0000
Message-ID: <20160118134339.GA16263@IND12F0122> (sfid-20160118_145725_393039_6EAED3C3)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hari Prasath Gujulan Elango <hgujulan@visteon.com>

This patch move's a macro defined in the middle of a structure
definition to make it more readable.

Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index e961b50..875ea68 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -29,12 +29,12 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
 };
 
 #define WILC_SDIO_BLOCK_SIZE 512
+#define MAX_NUN_INT_THRPT_ENH2 (5) /* Max num interrupts allowed in registers 0xf7, 0xf8 */
 
 typedef struct {
 	bool irq_gpio;
 	u32 block_size;
 	int nint;
-#define MAX_NUN_INT_THRPT_ENH2 (5) /* Max num interrupts allowed in registers 0xf7, 0xf8 */
 	int has_thrpt_enh3;
 } wilc_sdio_t;
 
-- 
1.9.1
