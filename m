Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay02.solcon.nl ([212.45.32.108]:38285 "EHLO
	mailrelay02.solcon.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797Ab2J3T6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 15:58:11 -0400
Message-ID: <5090314E.7070703@solcon.nl> (sfid-20121030_205815_930483_8EE6503E)
Date: Tue, 30 Oct 2012 20:58:06 +0100
From: Albert Pool <albertpool@solcon.nl>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: stable@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: rtlwifi: rtl8192cu: Add new USB ID
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an ISY IWL 2000. Probably a clone of Belkin F7D1102 050d:1102. 
Its FCC ID is the same.

Signed-off-by: Albert Pool <albertpool@solcon.nl>
---
  drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c 
b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
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

