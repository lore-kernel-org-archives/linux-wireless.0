Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55141 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1BHIoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 03:44:13 -0500
Received: by iyj8 with SMTP id 8so3047991iyj.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 00:44:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297151826.2064.68.camel@wimaxnb.nmp.nokia.com>
References: <1297078254-4664-1-git-send-email-juuso.oikarinen@nokia.com>
 <AANLkTinKyrP2fiE-3+nFeHxvKvg_pn02dLc=t-_+VUJS@mail.gmail.com>
 <1297081781.2064.12.camel@wimaxnb.nmp.nokia.com> <AANLkTim2H+s0mM+7HBubEHbYj5O+PRHDkeJefx64zRKx@mail.gmail.com>
 <1297083534.2064.19.camel@wimaxnb.nmp.nokia.com> <AANLkTim6J9yizLPcj-ERwVEcp=VXSymXBfFdszHUMp80@mail.gmail.com>
 <1297151826.2064.68.camel@wimaxnb.nmp.nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 8 Feb 2011 10:43:52 +0200
Message-ID: <AANLkTi=b7R3QRsKVPSBk7mvspO-HGZNdDzOgZaEO8Z4C@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: Allow wl12xx interrupts to wake up the host
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 8, 2011 at 9:57 AM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
>> It might mean your platforms are configured to hit retention (assuming
>> omap) or even off mode in the cpuidle path as well, and in that case
>> it can explain the enable_irq_wake..
>>
>> > I'm currently trying to find out if this is really needed or not.
>>
>> Sure, thanks.
>
> They are saying this is needed for OMAP's retention mode too

yes, it is.

> ,so AFAIK this is needed, not just for suspend.

so your platforms are configured to hit retention in cpuidle. nice.
