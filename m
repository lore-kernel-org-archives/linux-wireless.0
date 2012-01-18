Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4210 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab2ARHd5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 02:33:57 -0500
Message-ID: <4F1675DB.6070307@broadcom.com> (sfid-20120118_083401_119834_1F0CC24B)
Date: Wed, 18 Jan 2012 08:33:47 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: Dan <dannyai.mobile@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Brcmsmac drivers
References: <F18570BE-C886-4182-9D73-943283F3EB8D@gmail.com>
In-Reply-To: <F18570BE-C886-4182-9D73-943283F3EB8D@gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2012 01:08 AM, Dan wrote:
> Hi Arend,
> 
> I have been trying to get my BCM4313 wireless adapter to work in monitor mode under Linux. 
> 
> No matter what I try. I can't seem to get aircrack to capture data from the APs. I can capture beacons but data is always zero within airodump-ng. 
> 
> Is this a missing feature in the driver? Or a bug in the driver?

If you are using a mainline v3.2 than it is a missing feature. It will
arrive in mainline in v3.3-rc1.

> I've also had trouble compiling the latest bleeding compat-wireless. When loading the brcmsmac module it complains of some unknown symbol bcma_sonething something. 
> 
> My next step is to try and compile the brcmsmac drivers straight from the Linux wireless testing GIT branch. 

Yes. The current wireless-testing should contain monitor mode.

> Do you know the reason why monitor mode is unable to pick up data from APs?? 
> Maybe I need a different binary firmware or I need set some options in the driver.?
> 
> Thanks,
> Dan
> 
> 
> 

Gr. AvS

