Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from thb-mta-12-tx.emailfiltering.com ([194.116.199.210]:38862 "EHLO
	ixe-mta-12.emailfiltering.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752920Ab2CLVNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 17:13:31 -0400
Received: from [10.10.10.229] (account nikodem.ciesielski@microgen.com HELO [10.0.2.15])
  by microgen.pl (CommuniGate Pro SMTP 5.0.2)
  with ESMTPA id 1984902 for linux-wireless@vger.kernel.org; Mon, 12 Mar 2012 21:09:35 +0100
Message-ID: <4F5E658B.9060503@microgen.com> (sfid-20120312_221335_329696_AD453D56)
Date: Mon, 12 Mar 2012 22:07:23 +0100
From: Nikodem Ciesielski <nikodem.ciesielski@microgen.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 4addr explanation
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

The question is:
Does 4addr mode require that wireless device to support WDS mode?

I'm trying to achive the following:
- bridge wire and wireless interface (Broadcom BCM43224) on Dell Latitude E6510
  os: Ubuntu 11.10 with  iw 3.3 (compiled and installed)
- setting wireless interface to 4addr mode and managed mode
- connect to Asus RT-n16 (firmware: TomatoUSB by shibby 1.28.0000 MIPSR2-085V K26 USB AIO)
*- * setting router to AP+WDS mode and add Laptop wireless MAC to WDS device

Simply I want to bridge wireless and wire intterface to work like an ordinary (wire) ethernet bridge.
And I can't. I followed the instrucion from:
http://nullroute.eu.org/~grawity/not-a-blog.html
topic: VirtualBox bridged network and WLAN

I think that my router refuse 4addr packages but I'm not sure.
Broadcom BCM43224 does not support WDS mode,
however it seems that 4addr mode can be set
and the wirelass card is able to assing with the router.
What can I do?

Best regards
Nikodem Ciesielski


________________________________________________________________________
This email is confidential, may also be privileged and is subject to the information set out at http://www.microgen.com/emailinfo/ which forms part of this email.
