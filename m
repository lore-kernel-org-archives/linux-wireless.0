Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:42198 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754535AbeBPPMN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:12:13 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/12] staging: wilc1000: fix line over 80 char in wilc_wlan_cfg_set_str()
Date: Fri, 16 Feb 2018 20:41:42 +0530
Message-ID: <1518793909-15573-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180216_161219_261434_6288F137)
In-Reply-To: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "line over 80 characters" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index aeb5417..c4b3d8d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -221,7 +221,8 @@ static int wilc_wlan_cfg_set_word(u8 *frame, u32 offset, u16 id, u32 val32)
 	return 8;
 }
 
-static int wilc_wlan_cfg_set_str(u8 *frame, u32 offset, u16 id, u8 *str, u32 size)
+static int wilc_wlan_cfg_set_str(u8 *frame, u32 offset, u16 id, u8 *str,
+				 u32 size)
 {
 	u8 *buf;
 
-- 
2.7.4
