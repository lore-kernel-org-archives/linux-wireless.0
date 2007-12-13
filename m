Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta16.adelphia.net ([68.168.78.211]:52217 "EHLO
	mta16.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbXLMArD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 19:47:03 -0500
Message-ID: <47608102.5010105@roadrunner.com> (sfid-20071213_004708_514839_63DB04B2)
Date: Wed, 12 Dec 2007 19:46:58 -0500
From: Randy Cushman <rcushman_linux@roadrunner.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: BCM4306 Questions
References: <475F2DAD.4000708@roadrunner.com> <200712121214.50522.mb@bu3sch.de> <475FCB46.2030209@roadrunner.com> <200712121300.59811.mb@bu3sch.de>
In-Reply-To: <200712121300.59811.mb@bu3sch.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Not at all.
> You have to read the webpage. Here's the link again:
> http://www.linuxwireless.org/en/users/Drivers/b43#devicefirmware
> Everything is described there.
>
>   
Thank you for being patient with me.

When I read that web page for the fourth time, I finally realized that 
what I needed to do was forget about using the correct driver for my 
adapter, and instead download an ancient driver for an unidentified 
adapter from a website of unknown authenticity, and use the firmware 
from that driver instead.  Should have been obvious, I guess.

Then all I had to do was try every combination of settings in the 
"Connect to Wireless Network" dialog.  Once I clicked the "show 
credentials" box, I was up and running.

Now I realize that my offer to add the signature for the latest driver 
for my adapter to bcm43xx-fwcutter would be pointless, as bcm43xx 
apparently does not support v4.x firmware.

Perhaps when I have some free time I can build the b43 driver and give 
it a test drive. 

Thanks again.

