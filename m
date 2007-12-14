Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta10.adelphia.net ([68.168.78.202]:64987 "EHLO
	mta10.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759058AbXLNBnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 20:43:09 -0500
Message-ID: <4761DFA9.3020305@roadrunner.com> (sfid-20071214_014312_560424_420BDFD1)
Date: Thu, 13 Dec 2007 20:43:05 -0500
From: Randy Cushman <rcushman_linux@roadrunner.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: BCM4306 Questions
References: <475F2DAD.4000708@roadrunner.com>	 <200712121214.50522.mb@bu3sch.de> <475FCB46.2030209@roadrunner.com>	 <200712121300.59811.mb@bu3sch.de>  <47608102.5010105@roadrunner.com> <1197508664.13188.27.camel@dv>
In-Reply-To: <1197508664.13188.27.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> Hello!
>
>   
>> Thank you for being patient with me.
>>
>> When I read that web page for the fourth time, I finally realized that 
>> what I needed to do was forget about using the correct driver for my 
>> adapter, and instead download an ancient driver for an unidentified 
>> adapter from a website of unknown authenticity, and use the firmware 
>> from that driver instead.  Should have been obvious, I guess.
>>     
>
> I have looked at that page, and I don't see anything confusing there.  I
> wish I could improve it, but I don't see how.
>
> The firmware checksum is verified, so either you are getting the right
> firmware, or you are not getting any.
>
> There is no talk of choosing "the correct driver".  Instead, the page
> suggests downloading both firmwares rather than guessing:
>
>   
Considered by itself the web page makes sense.

However considering how I process information, along with additional 
factors, the process caused difficulty for me:
1) The bcm43xx-fwcutter man page and its -l option contradict the web 
page, indicating that firmware can be extracted from recent versions of 
bcmwl5.sys (include many versions 4.x) for use with bcm43xx.
2) Personal experience:  The driver Windows XP found for this HP adapter 
was unstable.  This led me to treat as suspect any driver not obtained 
from HP.
3) I had no way of knowing that firmware from any random driver would 
work with my adapter.
4) I preferred using a driver/firmware from a trusted website over one 
from an unknown website.

The above information led me to believe that I already had an 
appropriate driver, so when reading the web page I repeatedly skipped 
over the section discussing driver downloads.

I don't think any changes to the web page are needed.  At the first sign 
of trouble I should have read the instructions more carefully and 
considered the possibility that there was a reason I was being 
instructed to download a particular driver.

