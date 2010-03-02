Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.polymtl.ca ([132.207.4.11]:47517 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab0CBWu6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 17:50:58 -0500
Message-ID: <4B8D9649.8020907@polymtl.ca>
Date: Tue, 02 Mar 2010 17:50:49 -0500
From: William Bourque <william.bourque@polymtl.ca>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com> <201003022257.51878.mb@bu3sch.de> <4B8D906C.9020102@polymtl.ca> <201003022329.58627.mb@bu3sch.de>
In-Reply-To: <201003022329.58627.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Michael Buesch wrote:
> On Tuesday 02 March 2010 23:25:48 William Bourque wrote:
>> So if I get this right, this code is responsible of handling the b43
>> devices, as well as several other PCI-E devices, correct?
> 
> Nah, this is a broadcom specific thing of the on-chip SSB bus.
> 
Ok, sorry then :)

>> Because now that you mention this, the wired network card (Marvel Yukon,
>> with sky2 drivers) on this netbook also have a tons of issue (doesn't
>> show in lspci on a clean boot, oops the kernel if network cable is
>> unplugged while in use, fails to load if the module is ever unloaded, ... )
>> I thought it was unrelated but from your comment, I feel like this could
>> be linked to the same PCI-E bugs as well.
> 
> Uh, well. Are you sure your hardware is OK then?
> 
I sure hope so. The laptop is very new and I never had trouble with it,
but to tell the truth, it is a refurbished model so can't say for sure.

I think the hardware is fine but there is _very weird_ stuff about the
laptop... I feel like their ACPI implemention is nowhere near standard
and that might cause the problems. It's like everything on this laptop
is under a very agressive power management that bypass the OS and
confuse drivers. But again, it's just a feeling, I don't really have
much facts that back up this theory ;)

- William
