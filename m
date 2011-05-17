Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1866 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1EQCce (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 22:32:34 -0400
Message-ID: <4DD1DE34.90403@broadcom.com> (sfid-20110517_043238_515504_12175BD5)
Date: Mon, 16 May 2011 19:32:20 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: Steve <steve.obrien@hdesd.org>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	driverdevel <devel@driverdev.osuosl.org>
Subject: Re: Broadcom 4331 wireless device
References: <AANLkTinBTXduB-uQp7FqNjPdzUm5=0v8vrE79oi5Toez@mail.gmail.com>
 <AANLkTikHx2J-zzCob+xVy04=RYX+K9T2HJ_14zyrto2J@mail.gmail.com>
 <loom.20110425T203659-857@post.gmane.org>
In-Reply-To: <loom.20110425T203659-857@post.gmane.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/25/2011 11:38 AM, Steve wrote:
>>
>> So yes, it looks like new BCM4331 chipset. AFAIK there is no support
>> for it in wl. Plus no support in b43 or brcm80211.
>>
>
> Any news? I also looking for a linux driver for the 4331 and have had no luck
> with wl.
> Steve

We have plans to support the BCM4331, and other new chips, with the 
brcmsmac driver.  I don't have an ETA, but new chip support is the first 
thing on the priority list after getting the brcmsmac driver out of staging.

---
Henry Ptasinski
henryp@broadcom.com

