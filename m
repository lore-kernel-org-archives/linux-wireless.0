Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cernmx13.cern.ch ([137.138.142.200]:9432 "EHLO cernmx13.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbZFGL1b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 07:27:31 -0400
Message-ID: <4A2BA2E0.7020709@cern.ch>
Date: Sun, 7 Jun 2009 13:22:08 +0200
From: Wojciech Zabolotny CERN <wojciech.zabolotny@cern.ch>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: Which firmware for Belkin F5D7050 (ISL3880 + NET2280)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I have the Belkin F5D7050 WiFi card with the following chips:
1. NET2280 REV1A-LF
2. ISL3880IK

Which firmware should I use?
It seemed to me, that the proper choice is the:

USB 1st generation (ISL3886 + net2280)  isl3886usb

download
<http://daemonizer.de/prism54/prism54-fw/fw-usb/2.13.24.0.lm86.arm>

However, when I try to use it, I get the following info in my logs:

usb 1-5: firmware: requesting isl3886usb
phy3: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2392
phy3: FW rev 2.13.24.0 - Softmac protocol 5.9
phy3: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
p54usb: probe of 1-5:1.0 failed with error -110
usbcore: registered new interface driver p54usb


Is this problem associated with the incorrect firmware version
or with something else?
-- 
TIA & BR,
WZab

