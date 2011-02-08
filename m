Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:34368 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab1BHH5K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 02:57:10 -0500
Subject: Re: [PATCH] wl12xx: Allow wl12xx interrupts to wake up the host
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTim6J9yizLPcj-ERwVEcp=VXSymXBfFdszHUMp80@mail.gmail.com>
References: <1297078254-4664-1-git-send-email-juuso.oikarinen@nokia.com>
	 <AANLkTinKyrP2fiE-3+nFeHxvKvg_pn02dLc=t-_+VUJS@mail.gmail.com>
	 <1297081781.2064.12.camel@wimaxnb.nmp.nokia.com>
	 <AANLkTim2H+s0mM+7HBubEHbYj5O+PRHDkeJefx64zRKx@mail.gmail.com>
	 <1297083534.2064.19.camel@wimaxnb.nmp.nokia.com>
	 <AANLkTim6J9yizLPcj-ERwVEcp=VXSymXBfFdszHUMp80@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 09:57:06 +0200
Message-ID: <1297151826.2064.68.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-07 at 16:56 +0200, ext Ohad Ben-Cohen wrote:
> On Mon, Feb 7, 2011 at 2:58 PM, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> > Actually this I don't see any performance impact for better or worse of
> > this patch on brief testing. I was instructed by some of our other
> > kernel-dudes that this is actually needed for the cpuidle path too, or
> > there might be some implications.
> 
> It might mean your platforms are configured to hit retention (assuming
> omap) or even off mode in the cpuidle path as well, and in that case
> it can explain the enable_irq_wake..
> 
> > I'm currently trying to find out if this is really needed or not.
> 
> Sure, thanks.

They are saying this is needed for OMAP's retention mode too, so AFAIK
this is needed, not just for suspend.

-Juuso

