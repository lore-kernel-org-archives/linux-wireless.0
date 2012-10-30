Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay02.solcon.nl ([212.45.32.108]:46097 "EHLO
	mailrelay02.solcon.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2J3M5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 08:57:14 -0400
Received: from [87.195.155.5] (helo=[192.168.1.68])
	by mailrelay02.solcon.nl with esmtpa (Exim 4.72)
	(envelope-from <albertpool@solcon.nl>)
	id 1TTBNa-0000nN-BL
	for linux-wireless@vger.kernel.org; Tue, 30 Oct 2012 13:57:14 +0100
Message-ID: <508FCEA9.6000504@solcon.nl> (sfid-20121030_135718_016009_323E26EA)
Date: Tue, 30 Oct 2012 13:57:13 +0100
From: Albert Pool <albertpool@solcon.nl>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org
Subject: rtl8192cu: ISY IWL 2000 USB ID added
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can't get the device to connect to my wifi, but it at least detects networks with this patch.
Probably a clone of Belkin F7D1102 050d:1102. Its FCC ID is the same.
---
  drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index d228358..64a247b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -297,6 +297,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
  	/*=== Customer ID ===*/
  	/****** 8188CU ********/
  	{RTL_USB_DEVICE(0x050d, 0x1102, rtl92cu_hal_cfg)}, /*Belkin - Edimax*/
+	{RTL_USB_DEVICE(0x050d, 0x11f2, rtl92cu_hal_cfg)}, /*Belkin - ISY*/
  	{RTL_USB_DEVICE(0x06f8, 0xe033, rtl92cu_hal_cfg)}, /*Hercules - Edimax*/
  	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
  	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
-- 
1.7.5.4

