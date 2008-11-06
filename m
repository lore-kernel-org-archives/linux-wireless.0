Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33122 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbYKFBAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 20:00:36 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KxtEd-0004Wv-As
	for linux-wireless@vger.kernel.org; Thu, 06 Nov 2008 01:00:31 +0000
Received: from ppp-88-217-36-175.dynamic.mnet-online.de ([88.217.36.175])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 01:00:31 +0000
Received: from berni by ppp-88-217-36-175.dynamic.mnet-online.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 01:00:31 +0000
To: linux-wireless@vger.kernel.org
From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: b43: Everybody with PHY TX error, please try
Date: Thu, 6 Nov 2008 01:00:21 +0000 (UTC)
Message-ID: <getfj5$vl5$3@ger.gmane.org> (sfid-20081106_020040_888237_D4F2E4C2)
References: <200810242032.04295.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> wrote:

> Everybody with PHY TX error, please try updated firmware from
> ftp://ftp.linksys.com/opensourcecode/wrt610n/1.00.00.018/wrt610n_v1.00.00.018_us.tgz
> (Yeah, big tarball. It's 87MB)
>
> Extract the file wrt610n_v1.00.00.018_us/release/src/wl/linux/wl.o out of the archive.
> Get latest b43-tools:
> git clone http://git.bu3sch.de/git/b43-tools.git
>
> Build and install fwcutter from latest b43-tools.git
>
> Extract the firmware from the wl.o file:
> b43-fwcutter --unsupported -w /lib/firmware/DESTPATH  wl.o
>
> Try to reproduce the PHY TX error with the new firmware.

Still getting them, OpenWRT Kamikaze trunk on a Linksys WRT54G

b43-phy0: Broadcom 5352 WLAN found
b43-phy0 debug: Found PHY: Analog 2, Type 2, Revision 7
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
b43-phy0 debug: DebugFS (CONFIG_DEBUG_FS) not enabled in kernel config
input: b43-phy0 as /devices/virtual/input/input0
b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
Registered led device: b43-phy0::radio
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
b43-phy0 debug: Removing Interface type 2
b43-phy0 debug: Wireless interface stopped
b43-phy0 debug: DMA-32 rx_ring: Used slots 0/64, Failed frames 0/0 =
0.0%, Average tries 0.00
b43-phy0 debug: DMA-32 tx_ring_AC_BK: Used slots 0/128, Failed frames
0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-32 tx_ring_AC_BE: Used slots 0/128, Failed frames
0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-32 tx_ring_AC_VI: Used slots 0/128, Failed frames
0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-32 tx_ring_AC_VO: Used slots 0/128, Failed frames
0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-32 tx_ring_mcast: Used slots 0/128, Failed frames
0/0 = 0.0%, Average tries 0.00
input: b43-phy0 as /devices/virtual/input/input1
b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)

Bernhard

