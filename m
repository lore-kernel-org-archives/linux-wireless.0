Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0136.outbound.protection.outlook.com ([157.55.234.136]:58752
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751761AbbFCKUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 06:20:51 -0400
From: "Sharma, Abhishek (A.)" <asharm14@visteon.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: wilc1000: Remove commented variable declerations
Date: Wed, 3 Jun 2015 10:06:14 +0000
Message-ID: <DB4PR06MB01614B5658E23A307437186C8B40@DB4PR06MB016.eurprd06.prod.outlook.com> (sfid-20150603_122056_356601_CCEDBDB1)
References: <20150603095523.GA25864@jarvis.asia.jci.com>
In-Reply-To: <20150603095523.GA25864@jarvis.asia.jci.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please discard this patch . I will send V2 of it .

-----Original Message-----
From: Sharma, Abhishek (A.) 
Sent: Wednesday, June 03, 2015 3:26 PM
To: Johnny Kim; Rachel Kim; Dean Lee; Chris Park; Greg Kroah-Hartman; linux-wireless@vger.kernel.org; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: Remove commented variable declerations

Removing the commented static variable declerations.

Signed-off-by: Abhishek Sharma <asharm14@visteon.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index e63788f..e1d9755 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -29,10 +29,6 @@ int sdio_xfer_cnt(void);  uint32_t wilc_get_chipid(uint8_t update);
 WILC_Uint16 Set_machw_change_vir_if(WILC_Bool bValue);
 
-/* static uint32_t vmm_table[WILC_VMM_TBL_SIZE]; */
-/* static uint32_t vmm_table_rbk[WILC_VMM_TBL_SIZE]; */
-
-/* static uint32_t vmm_table_rbk[WILC_VMM_TBL_SIZE]; */
 
 
 typedef struct {
--
2.1.4
