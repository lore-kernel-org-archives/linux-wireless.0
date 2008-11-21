Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35785 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYKUAjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 19:39:19 -0500
Date: Fri, 21 Nov 2008 01:39:18 +0100
From: Cyril Hrubis <metan@ucw.cz>
To: linux-wireless@vger.kernel.org
Cc: dsd@gentoo.org, kune@deine-taler.de
Subject: zd1211rw breaks s2ram
Message-ID: <20081121003918.GA6037@atrey.karlin.mff.cuni.cz> (sfid-20081121_013924_853703_FBB9886A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
on my asus eee 1000h notebook, an Usb wifi with driver zd1211rw breaks
s2ram. Notebook hangs before suspending (with console on the screen)
and doesn't react to anyting but the power button. The dongle is
identified as:

idVendor           0x0ace ZyDAS
idProduct          0x1215 WLA-54L WiFi
bcdDevice           48.10
iManufacturer          16 ZyDAS
iProduct               32 USB2.0 WLAN

I'm using firmware version 4725 (that's default one in Gentoo), kernel
is vanilla 2.6.28-rc5.

When i run "ifconfig wlan0 up", I get 'ADDRCONF(NETDEV_UP): wlan0: link
is not ready' in dmesg, however scanning seems works fine.

-- 
metan
