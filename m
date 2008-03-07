Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-hub.emtest.sk ([158.193.4.12]:51275 "HELO sly.emtest.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756589AbYCGLlv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 06:41:51 -0500
Message-ID: <56429.192.168.10.195.1204883002.squirrel@sly.emtest.sk> (sfid-20080307_114215_310897_7B207B13)
Date: Fri, 7 Mar 2008 10:43:22 +0100 (CET)
Subject: zd1211rw - signal loss problem
From: linux@emtest.sk
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have usb wifi Zyxel G-202 (chipset:zd1211b).
I have tried kernel 2.6.25-rc3 and I have problem when signal lost.

When wifi lose signal (I power off AP), wifi disconnect. This is OK. But
when signal is back, wifi doesn't reconnect back to AP. Link level is 0
(iwconfig wlan0). When I do network scanning, I see the AP, and link level
is good.

Pavol Podolak
