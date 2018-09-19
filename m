Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33734 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729926AbeISLnV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:43:21 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 26/29] staging: wilc1000: remove unnecessary option used with ccflags-y in Makefile
Date: Wed, 19 Sep 2018 11:35:16 +0530
Message-ID: <1537337119-14952-27-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080704_270002_63DEFEEC)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove -I(src) and -DWILC_ASIC_A0 option used in
ccflag-y in Makefile.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 5718bc4..37e8560 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -4,8 +4,6 @@ obj-$(CONFIG_WILC1000) += wilc1000.o
 ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
 		-DFIRMWARE_1003=\"atmel/wilc1003_firmware.bin\"
 
-ccflags-y += -I$(src)/ -DWILC_ASIC_A0
-
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			coreconfigurator.o host_interface.o \
 			wilc_wlan_cfg.o wilc_wlan.o
-- 
2.7.4
