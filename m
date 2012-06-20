Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([125.18.18.171]:23842 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab2FTO55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 10:57:57 -0400
From: Girish Bn <Girish.BN@lnties.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Compat Wireless Version - WL1271
Date: Wed, 20 Jun 2012 14:47:40 +0000
Message-ID: <45566970CF58C74CB52107862E0541CD1D172F55@POCITMSEXMB02.LntUniverse.com> (sfid-20120620_165800_760503_5070CEB8)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
We are using TI WL1271 to support Wi-FI/Wi-Fi Direct for Printer products
The system configuration is as follows
Processor: NXP LPC313X
Kernel: Linux 2.6.28.2
RAM:32MB
FLASH:16MB
We have ported the Compat Wireless 3.4 RC3(http://wireless.kernel.org/en/users/Download/stable#Patches) package successfully for prototyping.
However we have disabled Power Management related references in drivers/net/wl12xx/sdio.c as ours is a older kernel which doesn't support run-time PM.
We will be using the following Wi-Fi related features
1.  Wi-Fi Direct( As a Group Owner Negotiation or Autonomous GO), Legacy STA Client (Infrastructure Mode)
2. Wireless Personal and Enterprise Security (EAP-FAST, EAP_PEAPv1)
Let us know which version of Compat wireless package, Wl1271 Firmware version, WPA Supplicant and IW tools can be used in our system?
Let us know whether we can use following packages
1 .Compat Wireless 3.5 RC2
2. WPA Supplicant ver 1.0
3. IW Tools - ver 3.4
4. WL1271 Firmware version - ?

Let us know how to enable Power Management in the WL1271 driver and also kernel patches to enable the Power Management as this very critical

Thanks and Regards
Girish
Larsen & Toubro Limited

www.larsentoubro.com

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
