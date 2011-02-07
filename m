Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62412 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1BGO5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 09:57:42 -0500
Received: by iyj8 with SMTP id 8so2210641iyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Feb 2011 06:57:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297083534.2064.19.camel@wimaxnb.nmp.nokia.com>
References: <1297078254-4664-1-git-send-email-juuso.oikarinen@nokia.com>
 <AANLkTinKyrP2fiE-3+nFeHxvKvg_pn02dLc=t-_+VUJS@mail.gmail.com>
 <1297081781.2064.12.camel@wimaxnb.nmp.nokia.com> <AANLkTim2H+s0mM+7HBubEHbYj5O+PRHDkeJefx64zRKx@mail.gmail.com>
 <1297083534.2064.19.camel@wimaxnb.nmp.nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 7 Feb 2011 16:56:20 +0200
Message-ID: <AANLkTim6J9yizLPcj-ERwVEcp=VXSymXBfFdszHUMp80@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: Allow wl12xx interrupts to wake up the host
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 7, 2011 at 2:58 PM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> Actually this I don't see any performance impact for better or worse of
> this patch on brief testing. I was instructed by some of our other
> kernel-dudes that this is actually needed for the cpuidle path too, or
> there might be some implications.

It might mean your platforms are configured to hit retention (assuming
omap) or even off mode in the cpuidle path as well, and in that case
it can explain the enable_irq_wake..

> I'm currently trying to find out if this is really needed or not.

Sure, thanks.
