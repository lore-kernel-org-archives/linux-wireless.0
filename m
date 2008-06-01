Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12407 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbYFAFjs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2008 01:39:48 -0400
Subject: Re: Moving to kernel .25-r4
From: Pavel Roskin <proski@gnu.org>
To: iElectric <ielectric@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20080531T203112-538@post.gmane.org>
References: <loom.20080531T203112-538@post.gmane.org>
Content-Type: text/plain
Date: Sun, 01 Jun 2008 01:39:45 -0400
Message-Id: <1212298785.6853.5.camel@rd> (sfid-20080601_073953_366872_08DEF435)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-31 at 20:33 +0000, iElectric wrote:
> Recently I moved to kernel .25-r4. I want to use newest firmware version with
> b43 for my 4311 rev 1 wireless card. I cut the firmware to /lib/firmware/b43/,
> do rmmod b43, modprobe b43 and it still uses old firmware:
> 
> b43-phy0: Broadcom 4311 WLAN found
> b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 8
> b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
> b43-phy0 debug: DebugFS (CONFIG_DEBUG_FS) not enabled in kernel config
> b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)

That's the new firmware.

> Ideas? 

A good bug report describes:

1) What you do (you missed some details, such as the firmware name)
2) What you get (that was mostly OK)
3) What you expect to get (that was missing completely)

-- 
Regards,
Pavel Roskin
