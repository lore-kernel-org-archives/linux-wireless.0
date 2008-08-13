Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s17.blu0.hotmail.com ([65.55.111.92]:49554 "EHLO
	blu0-omc2-s17.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbYHMOIV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 10:08:21 -0400
Message-ID: <BLU144-W261CF289A7CDEA2BABB0B4D1730@phx.gbl> (sfid-20080813_160825_522740_9C1B469D)
From: d i <navilein@hotmail.com>
To: <linux-wireless@vger.kernel.org>
CC: <navilein@hotmail.com>
Subject: p54usb not working on DWL-G120 Spinnaker wireless card
Date: Wed, 13 Aug 2008 14:02:09 +0000
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,
I can't get my wireless card DWL-G120 Spinnaker to work with the p54usb module which is in the kernel tree. 
The kernel help page for the p54usb module says that this module should work with the DWL-G120 Spinnaker wireless card.
 
I now have kernel 2.6.25-r7, but I kept trying to use the p54usb module with my card unsuccessfully since it appeared in the kernel tree (around February this year) -- it never worked. 
I use firmware version 2.5.6.0 from the prism54.org website. I tried with other versions of firmware as well, but most of them did not even load up (error -22 and error -110).
 
With firmware 2.5.6.0 the module loads up, but scanning for APs reveals no answer, ever. If I set an ESSID of a network I KNOW is around and not crypted it does not set the AP address and the "Link Quality" is always 0  and  it never connects.
The card can not be set in monitor mode.
I can set the card in ad-hoc mode ONLY if the interface is down. If afterwards I try to bring the interface up (with ifconfig), I get an error, and the interface does not come up.
After a while (never fixed) the kernel Oops. 
 
Both the failure to work and the final unpredictable kernel Oops are always reproducible, although the time it takes the kernel to Oops varies every time.
 
I've tried this with 3 desktop computers and 1 laptop and all have the same behavior. The wireless card works well in windows or in linux under ndiswrapper.
 
Did anyone manage to have this wireless card (DWL-G120) working with this module (p54usb) ?
 
Thanks,
Daniel.
 
If you have an answer or comment, please CC the message to my email: navilein@hotmail.com
_________________________________________________________________
News, entertainment and everything you care about at Live.com. Get it now!
http://www.live.com/getstarted.aspx