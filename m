Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49148 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758820AbXLNEVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 23:21:06 -0500
Message-ID: <20071213232103.kbrglyv2848c444w@webmail.spamcop.net> (sfid-20071214_042114_421511_2E9DA344)
Date: Thu, 13 Dec 2007 23:21:03 -0500
From: Pavel Roskin <proski@gnu.org>
To: Randy Cushman <rcushman_linux@roadrunner.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: BCM4306 Questions
References: <475F2DAD.4000708@roadrunner.com>
	<200712121214.50522.mb@bu3sch.de> <475FCB46.2030209@roadrunner.com>
	<200712121300.59811.mb@bu3sch.de> <47608102.5010105@roadrunner.com>
	<1197508664.13188.27.camel@dv> <4761DFA9.3020305@roadrunner.com>
In-Reply-To: <4761DFA9.3020305@roadrunner.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Randy Cushman <rcushman_linux@roadrunner.com>:

> However considering how I process information, along with additional
> factors, the process caused difficulty for me:
> 1) The bcm43xx-fwcutter man page and its -l option contradict the web
> page, indicating that firmware can be extracted from recent versions of
> bcmwl5.sys (include many versions 4.x) for use with bcm43xx.

OK, this part could probably be "deemphasized" or preceded with the  
comment that the latest firmware in not necessarily the best, at least  
for the purpose of the reverse engineered driver.

In the same time, support for extracting the firmware from the new  
drivers could be added, just to provide such option for whatever  
reasons.

> 2) Personal experience:  The driver Windows XP found for this HP
> adapter was unstable.  This led me to treat as suspect any driver not
> obtained from HP.

The firmware in "soft-MAC" devices has little effect on stability.   
It's the driver that does most of the work and communicates with the  
OS.  The driver is not being extracted, only the firmware.

> 3) I had no way of knowing that firmware from any random driver would
> work with my adapter.
> 4) I preferred using a driver/firmware from a trusted website over one
> from an unknown website.

OK, that's just healthy skepticism :)

Thanks for your detailed answers.  It may help create a better  
experience for the future users.

-- 
Regards,
Pavel Roskin
