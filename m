Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.13]:49741 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab3DXPSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 11:18:53 -0400
Message-ID: <5177F7D6.2020800@einfach.org> (sfid-20130424_171857_836844_462EA8BD)
Date: Wed, 24 Apr 2013 16:18:46 +0100
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org, frankyl@broadcom.com,
	meuleman@broadcom.com, brudley@broadcom.com,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?B?5rW36Je75pWs5LmL?= <tkaiso@thinktube.com>
Subject: Re: Broadcom brcmfmac vs bcmdhd on Android
References: <5176ABB1.2070506@einfach.org> <5176F8C2.7050502@broadcom.com>
In-Reply-To: <5176F8C2.7050502@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/23/2013 10:10 PM, Arend van Spriel wrote:
> I am working mainly on brcmfmac. IBSS should work, but reading the
> commit message of your patch I guess it may be a firmware issue so using
> brcmfmac will not make a difference.

I would like to try that to confirm it. And from your message I conclude 
the brcmfmac is the way to go forward...

>> I succeeded to compile brcmfmac from recent compat-drivers against the
>> "tuna" (Galaxy Nexus) kernel, the modules load, but no device is
>> recognized. Has anyone succeeded doing this? Is there any chance it can
>> work?
>
> That is how we did it and with success. What do you mean by 'no device
> is recognized'? Do you have any traces to look at?

Good to know. What I did is I compiled the "tuna" kernel (3.0.31) 
without bcmdhd, then brcmfmac from compat-drivers, loaded the brcmfmac 
module (+ dependencies), but then nothing happens. It looks like the 
device is not recognized on SDIO. Is there anything special I need to do 
to activate the chip?
Anyhow I'll debug this further and send you more info later.

Thanks,
bruno


