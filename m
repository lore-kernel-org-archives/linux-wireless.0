Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40176 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab0IBSEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 14:04:30 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Sep 2010 11:04:25 -0700
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: "greg@kroah.com" <greg@kroah.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Date: Thu, 2 Sep 2010 11:04:29 -0700
Subject: RE: [PATCH 0/1] ath6kl: add ath6kl driver for AR6003 chip
Message-ID: <35B17FE5076C7040809188FBE7913F983F234795D5@SC1EXMB-MBCL.global.atheros.com>
References: <1283381473-20415-1-git-send-email-vmehta@atheros.com>
 <87tym8vdio.fsf@macbook.be.48ers.dk>
In-Reply-To: <87tym8vdio.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have not looked at the version of the driver being mentioned here but if it is based on an earlier GPL release from Atheros, then you might find some feature additions and bug fixes in this version of the driver. The ath6kl driver now supports AR6003 (the latest version of the chip) and has addressed some shortcomings based on the feedback from the shipping customers and internal QA. Some of these fixes or enhancements may have also gone in the firmware which can only work with this version of the driver and the chip.

Regards,
Vipin

> -----Original Message-----
> From: Peter Korsgaard [mailto:jacmet@gmail.com] On Behalf Of 
> Peter Korsgaard
> Sent: Wednesday, September 01, 2010 11:57 PM
> To: Vipin Mehta
> Cc: greg@kroah.com; Luis Rodriguez; 
> linux-wireless@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH 0/1] ath6kl: add ath6kl driver for AR6003 chip
> 
> >>>>> "Vipin" == Vipin Mehta <vmehta@atheros.com> writes:
> 
>  Vipin> The patch adds support for the 802.11 chip, AR6003. 
> It has been  Vipin> generated against the linux-next tree and 
> is being targeted  Vipin> for the staging area.
> 
>  Vipin> A little bit about the chip and driver:
>  Vipin> (Pls refer to 
> http://wireless.kernel.org/en/users/Drivers/ath6kl
>  Vipin> for details)
> 
> What is the relation to the (openmoko) ar6k driver for ar6000?
> 
> http://wireless.kernel.org/en/users/Drivers/ar6k
> 
> --
> Bye, Peter Korsgaard
> 