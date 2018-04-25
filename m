Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:58440 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756027AbeDYRTq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:46 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 09/21] staging: wilc1000: remove unsed typedef wilc_debug_func
Date: Wed, 25 Apr 2018 22:48:14 +0530
Message-ID: <1524676706-13179-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191950_636634_C798A772)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unused typedef and also removed the
unecessary comment about that typedef.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 671e499..a5b9c68 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -202,13 +202,6 @@
 
 /********************************************
  *
- *      Debug Type
- *
- ********************************************/
-typedef void (*wilc_debug_func)(u32, char *, ...);
-
-/********************************************
- *
  *      Tx/Rx Queue Structure
  *
  ********************************************/
-- 
2.7.4
