Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:64459 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753917AbeDRLkw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:40:52 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 13/22] staging: wilc1000: remove multiple define for mac connect and disconnect
Date: Wed, 18 Apr 2018 17:09:15 +0530
Message-ID: <1524051564-15497-14-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134058_471193_658D30C4)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to have commonly used macro in common header file to avoid
same defination in mulitple file. Removed MAC_CONNECTED &
MAC_DISCONNECTED macro from coreconfigurator.h header.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 1666b7a..6e61f3d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -31,9 +31,6 @@
 #define MAX_STRING_LEN               256
 #define MAX_ASSOC_RESP_FRAME_SIZE    MAX_STRING_LEN
 
-#define MAC_CONNECTED                1
-#define MAC_DISCONNECTED             0
-
 #define MAKE_WORD16(lsb, msb) ((((u16)(msb) << 8) & 0xFF00) | (lsb))
 #define MAKE_WORD32(lsw, msw) ((((u32)(msw) << 16) & 0xFFFF0000) | (lsw))
 
-- 
2.7.4
