Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55596 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbYEaUfN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2008 16:35:13 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1K2Xn4-0005vB-6Y
	for linux-wireless@vger.kernel.org; Sat, 31 May 2008 20:35:02 +0000
Received: from 84-255-194-155.static.t-2.net ([84.255.194.155])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2008 20:35:02 +0000
Received: from ielectric by 84-255-194-155.static.t-2.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2008 20:35:02 +0000
To: linux-wireless@vger.kernel.org
From: iElectric <ielectric@gmail.com>
Subject: Moving to kernel .25-r4
Date: Sat, 31 May 2008 20:33:35 +0000 (UTC)
Message-ID: <loom.20080531T203112-538@post.gmane.org> (sfid-20080531_223518_354365_9AA28B36)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently I moved to kernel .25-r4. I want to use newest firmware version with
b43 for my 4311 rev 1 wireless card. I cut the firmware to /lib/firmware/b43/,
do rmmod b43, modprobe b43 and it still uses old firmware:

b43-phy0: Broadcom 4311 WLAN found
b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 8
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
b43-phy0 debug: DebugFS (CONFIG_DEBUG_FS) not enabled in kernel config
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2

Ideas? 

Also I can also confirm freezing after hibernation on HP lappy.

