Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s1.bay0.hotmail.com ([65.54.246.201]:55631 "EHLO
	bay0-omc3-s1.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111AbXHPUyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 16:54:05 -0400
Message-ID: <BAY111-F25D952C7E01CC8CB5A47B2B6DF0@phx.gbl>
From: "maali Al Janoob" <mms82@hotmail.com>
To: linux-wireless@vger.kernel.org
Subject: question for developers (help plzz!!)
Date: Fri, 17 Aug 2007 00:54:00 +0400
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I would like to get in touch with any of the developers of Realtek and 
Ralink linux drivers. My question to them is about the implementation of the 
binary exponential backoff (BEB) algorithm in the driver: is it part of the 
open-source driver code which is availabl for public access, or is it part 
of the binary-only firmware?
I came to know thorugh this mailing list that those two chipsets might not 
require a firmware, and that gave me hope in finding all the 802.11 
functionalities in the open source driver codes, but I have searched through 
the code of the Ralink 2571 usb driver and the Realtek 8187L driver - What I 
found was only specifying the min and max values of the contention window 
(cw), not the implementation of the BEB algorithm itselt.

Aside from this, if any one is aware of any chipset that implements ALL 
802.11 funcitonalities in open source software, please save me with it. I'm 
doing a masters thesis that requires modifying the BEB algorithm. I have 
tried the following chips so far with no hope: prism (wlan-ng), 
zd1211(zd1211rw), atheros(madwifi).

The smallest contribution of any of you will be of great value to me!

Regards,
Maali

_________________________________________________________________
Express yourself instantly with MSN Messenger! Download today it's FREE! 
http://messenger.msn.click-url.com/go/onm00200471ave/direct/01/

