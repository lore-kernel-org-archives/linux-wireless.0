Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:36945 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbZFAVrO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 17:47:14 -0400
Message-ID: <4A244C5A.50307@free.fr>
Date: Mon, 01 Jun 2009 23:47:06 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: b43 vs b43legacy
References: <loom.20090529T190620-42@post.gmane.org> <4A20505D.40908@lwfinger.net>
In-Reply-To: <4A20505D.40908@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Matthieu CASTET wrote:
>> what's the difference between b43 and b43legacy ?
>>
>> >From a first point a view, it seems b43 is for core >= 5 and b43legacy for the
>> other.
>> There is also firmware difference : b43 need v4 and b43legacy need v3.
> 
> The firmware difference is the primary one.
> 
>> But v4 firmware seems to support core 4 (pcm4 & ucode4) and b43 code got some
>> support for old chips (<5).
> 
> The Broadcom V4 drivers do have core 4 firmware embedded in them and it is
> extracted by b43-fwcutter; however, b43 will _NOT_ work with core 4 chips. The
> firmware loader will only find firmware for core 5 and later.
Ok but what prevent b43 to support core 4 chip with v4 firmware like the 
broadcom driver does ?
I am aware that the current driver doesn't support it, but what are the 
missing part to support it ?

If it is the difference from core4 from newer chip, why b43legacy 
contains only few special case for core4 chip.

> 
> I suspect that any residual code for older chips left in b43 was missed. If you
> want to prepare patches to remove such code, please do.
Yes, I could prepare such patches

Thanks

Matthieu

PS : I don't have core 4 chip nor plan to get some, I ask this out of 
curiosity.
