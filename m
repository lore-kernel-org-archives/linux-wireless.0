Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46871 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755019AbeDYRTd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:33 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 02/21] staging: wilc1000: align the #define in wilc_spi file
Date: Wed, 25 Apr 2018 22:48:07 +0530
Message-ID: <1524676706-13179-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191937_596477_F30F29A6)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to align the #define used in wilc_spi.c file by adding the
tabs.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 3bb8fec..600005c 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -92,29 +92,29 @@ static u8 crc7(u8 crc, const u8 *buffer, u32 len)
 
 #define CMD_DMA_WRITE				0xc1
 #define CMD_DMA_READ				0xc2
-#define CMD_INTERNAL_WRITE		0xc3
-#define CMD_INTERNAL_READ		0xc4
+#define CMD_INTERNAL_WRITE			0xc3
+#define CMD_INTERNAL_READ			0xc4
 #define CMD_TERMINATE				0xc5
-#define CMD_REPEAT					0xc6
-#define CMD_DMA_EXT_WRITE		0xc7
-#define CMD_DMA_EXT_READ		0xc8
+#define CMD_REPEAT				0xc6
+#define CMD_DMA_EXT_WRITE			0xc7
+#define CMD_DMA_EXT_READ			0xc8
 #define CMD_SINGLE_WRITE			0xc9
-#define CMD_SINGLE_READ			0xca
-#define CMD_RESET						0xcf
+#define CMD_SINGLE_READ				0xca
+#define CMD_RESET				0xcf
 
-#define N_OK								1
-#define N_FAIL								0
-#define N_RESET							-1
-#define N_RETRY							-2
+#define N_OK					1
+#define N_FAIL					0
+#define N_RESET					-1
+#define N_RETRY					-2
 
 #define DATA_PKT_SZ_256				256
-#define DATA_PKT_SZ_512			512
+#define DATA_PKT_SZ_512				512
 #define DATA_PKT_SZ_1K				1024
 #define DATA_PKT_SZ_4K				(4 * 1024)
 #define DATA_PKT_SZ_8K				(8 * 1024)
-#define DATA_PKT_SZ					DATA_PKT_SZ_8K
+#define DATA_PKT_SZ				DATA_PKT_SZ_8K
 
-#define USE_SPI_DMA     0
+#define USE_SPI_DMA				0
 
 static int wilc_bus_probe(struct spi_device *spi)
 {
-- 
2.7.4
