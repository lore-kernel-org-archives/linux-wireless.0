Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:37837 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756507AbZJVPp5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 11:45:57 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1N0zqZ-0000J8-RX
	for linux-wireless@vger.kernel.org; Thu, 22 Oct 2009 17:45:03 +0200
Received: from ppp-68-106.21-151.libero.it ([151.21.106.68])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2009 17:45:03 +0200
Received: from barx by ppp-68-106.21-151.libero.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2009 17:45:03 +0200
To: linux-wireless@vger.kernel.org
From: Alessandro Barisone <barx@email.it>
Subject: PHY transmission error on broadcom 4318
Date: Thu, 22 Oct 2009 17:37:17 +0200
Message-ID: <hbpu7b$6rk$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all

I have a broadcom 4318 on my laptop , acer ferrari 4005WLMI
The distro is
Slackware 13.0 with kernel 2.6.29.6
I'm using driver b43

linuxwireless.org says to use the latest firmware, 4.150.10.5
but using this version the wireless card doesn't work good
it connect, but in the syslog I get lots of errors 'b43-phy0 ERROR: PHY 
transmission error', and the card loose lots of packets.

This happens immediately, after few seconds of use.

Then i tried using a previous version of the firmware, version 4.80.53.0
This version works perfectly. I used it for 10 hours, trasferring some Gb of 
files.
But in the syslog I get the message "You are using an old firmware image. 
Support for old firmware will be removed in July 2008."
Now I still continue to use the old (deprecated, but working) firmware
But .. how to fix these errors with the newer firmware?

I read in the mailing list that some patch exists.. so, which is the best 
choice?

- continue to use the older firmware (what I'm doing now)
- upgrade the kernel (to which version?)
- use of some patch to kernel or module or firmware (as I have read 
somewhere in the mailing list)


