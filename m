Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:41185 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3KARHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 13:07:20 -0400
Received: by mail-oa0-f43.google.com with SMTP id m1so4832316oag.2
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 10:07:20 -0700 (PDT)
Message-ID: <5273DFC6.8000305@lwfinger.net> (sfid-20131101_180724_222318_26705E54)
Date: Fri, 01 Nov 2013 12:07:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ruben De Smet <ruben.de.smet@telenet.be>,
	b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: BCM43228
References: <52737A9C.3020404@telenet.be> <5273C948.9060409@lwfinger.net> <5273D018.7080607@telenet.be>
In-Reply-To: <5273D018.7080607@telenet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/01/2013 11:00 AM, Ruben De Smet wrote:
> AFAIK, broadcom only offers it's drivers for intel x86 and x64_86; I
> guess by MIPS, you mean the architecture? (why wouldn't the intel
> driver work? Pretty unknown on the subject ;) )
>
> I read the WIP mail about the 227 chip, I could possibly wait for that
> one to be released and test it out on mine?
>
> For the record: the issue I'm having is as follows: when connecting
> via the bluetooth part of the chip to my phone and using DUN to
> connect to the internet, everything works fine until I shut down the
> connection. Then my kernel panics. (Another issue of course is the
> fact that wl is the only closed source thing in my kernel running atm
> on my notebook...)
>
> On brcmsmac: is linux-wireless the right mailinglist to post to then?
> I see that the range of supported devices is more close to my chip
> than b43 is ;)
> I added brcm80211-dev-list@broadcom.com to this mail too, which looks
> like the more appropriate mailinglist to post the issue to.
>
> R
>
> PS. snippet of the output of 'lspci -nn':
>
> 03:00.0 Network controller [0280]: Broadcom Corporation BCM43228
> 802.11a/b/g/n [14e4:4359]
>
> Other information on request, will try to answer asap.

The MIPS drivers are part of the codes used in various SoC implementations used 
in wireless routers. Disassembling an x86 code stream is much harder than for a 
machine like MIPS where all instructions are the same size.

Larry


