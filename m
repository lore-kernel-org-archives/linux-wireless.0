Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:24046 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbeDXRHf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:07:35 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 2/2] staging: wilc1000: updated TODO list
Date: Tue, 24 Apr 2018 22:37:03 +0530
Message-ID: <1524589623-1534-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180424_190738_718323_5E391D12)
In-Reply-To: <1524589623-1534-1-git-send-email-ajay.kathat@microchip.com>
References: <1524589623-1534-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed the items from WILC1000 TODO list, which are already addressed
to keep it updated. The removed items are already taken care by
previously submitted patches.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---

If someone feels differently please update for this patch. There are
pending fixes for soft-ap, p2p mode and suspend/resume operation. Along
with code refactor and cleanup patches will include patches with fixes.

If there any input for TODO to address, which can help to make this
driver ready to mainline please suggest.


 drivers/staging/wilc1000/TODO | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
index c441beb..d123324 100644
--- a/drivers/staging/wilc1000/TODO
+++ b/drivers/staging/wilc1000/TODO
@@ -1,7 +1,4 @@
 TODO:
-- remove the defined feature as kernel versions
-- remove OS wrapper functions
-- remove custom debug and tracing functions
 - rework comments and function headers(also coding style)
 - Move handling for each individual members of 'union message_body' out
   into a separate 'struct work_struct' and completely remove the multiplexer
@@ -9,13 +6,8 @@ TODO:
   implementation of each message handler into the callsite of the function
   that currently queues the 'host_if_msg'.
 - make spi and sdio components coexist in one build
-- turn compile-time platform configuration (BEAGLE_BOARD,
-  PANDA_BOARD, PLAT_WMS8304, PLAT_RKXXXX, CUSTOMER_PLATFORM, ...)
-  into run-time options that are read from DT
 - support soft-ap and p2p mode
 - support resume/suspend function
-- replace SIOCDEVPRIVATE commands with generic API functions
-- use wext-core handling instead of private SIOCSIWPRIV implementation
 - convert all uses of the old GPIO API from <linux/gpio.h> to the
   GPIO descriptor API in <linux/gpio/consumer.h> and look up GPIO
   lines from device tree, ACPI or board files, board files should
-- 
2.7.4
