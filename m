Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:52433 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425214AbeCBOYH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:24:07 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 13/13] staging: wilc1000: rename u16DummyReasonCode to avoid camelCase
Date: Fri, 2 Mar 2018 19:52:49 +0530
Message-ID: <1520000569-27738-14-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_153349_028647_9EF31436)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2354666..a4ee175 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1795,11 +1795,11 @@ static void handle_disconnect(struct wilc_vif *vif)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	s32 result = 0;
-	u16 u16DummyReasonCode = 0;
+	u16 dummy_reason_code = 0;
 
 	wid.id = (u16)WID_DISCONNECT;
 	wid.type = WID_CHAR;
-	wid.val = (s8 *)&u16DummyReasonCode;
+	wid.val = (s8 *)&dummy_reason_code;
 	wid.size = sizeof(char);
 
 	wilc_optaining_ip = false;
-- 
2.7.4
