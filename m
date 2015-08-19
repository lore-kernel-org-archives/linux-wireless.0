Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38051 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbbHSPdd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 11:33:33 -0400
Received: by wicja10 with SMTP id ja10so11862703wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 08:33:31 -0700 (PDT)
From: Adrien Schildknecht <adrien+dev@schischi.me>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	kvalo@codeaurora.org, linville@tuxdriver.com, marex@denx.de,
	fzuuzf@googlemail.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adrien Schildknecht <adrien+dev@schischi.me>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH v2] rtlwifi: rtl8192cu: Add new device ID
Date: Wed, 19 Aug 2015 17:33:12 +0200
Message-Id: <1439998392-2979-1-git-send-email-adrien+dev@schischi.me> (sfid-20150819_173356_003292_19A773D0)
In-Reply-To: <55D495C8.6030906@lwfinger.net>
References: <55D495C8.6030906@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The v2 of NetGear WNA1000M uses a different idProduct: USB ID 0846:9043

Signed-off-by: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index 23806c2..fd4a535 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -321,6 +321,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
 	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
 	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
 	{RTL_USB_DEVICE(0x0846, 0x9041, rtl92cu_hal_cfg)}, /*NetGear WNA1000M*/
+	{RTL_USB_DEVICE(0x0846, 0x9043, rtl92cu_hal_cfg)}, /*NG WNA1000Mv2*/
 	{RTL_USB_DEVICE(0x0b05, 0x17ba, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
 	{RTL_USB_DEVICE(0x0bda, 0x5088, rtl92cu_hal_cfg)}, /*Thinkware-CC&C*/
 	{RTL_USB_DEVICE(0x0df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
-- 
2.5.0

