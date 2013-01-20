Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56448 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab3ATIyu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 03:54:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TwqgC-0007Lm-F5
	for linux-wireless@vger.kernel.org; Sun, 20 Jan 2013 09:55:04 +0100
Received: from 117.207.246.22 ([117.207.246.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jan 2013 09:55:04 +0100
Received: from ketan_kamat by 117.207.246.22 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jan 2013 09:55:04 +0100
To: linux-wireless@vger.kernel.org
From: Ketan Kamat <ketan_kamat@persistent.co.in>
Subject: wl12xx: does not connect to WPA2-personal
Date: Sun, 20 Jan 2013 08:47:39 +0000 (UTC)
Message-ID: <loom.20130120T094649-416@post.gmane.org> (sfid-20130120_095500_506521_E560651E)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luciano,

we are facing a problem with wl1271 module when connecting to WPA2-personal
network with ciper AES.It connects after successful authentication (without
getting IP address) and keeps retrying for IP address after connecting (and
suddenly disconnects as well).
We are using ubuntu 12.04 with linux kernel 3.4.7 built using stable-kernel
tree. wl12xx firmware loaded for wl12xx is 6.3.5.0.98. Hardware setup consists
of beagle board connected to the chipsee module that has touchscreen and the
wl1271 module.

I am mentioning two scenarios here:
1. Here we use a router that we can configure to different wifi security. If we
set the wifi network to open i.e security=None, wl1271 module gets connected.
Hence does not seem to be problem related to antenna or range.
2. If i remove driver for wl12xx and connect a USB dongle (r8712u), and try to
connect to the same WPA2-personal network.It works and gets the IP
address.However we want to use on board wl12xx module.

Is it the problem with the wl12xx driver? Any fix for this?

Does wpa2-personal work with wl12xx with latest Linux kernel (3.7.2)?

Any pointers towards this would be of great help.

Regards,
Ketan


