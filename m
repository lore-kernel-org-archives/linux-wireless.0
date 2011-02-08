Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:38253 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab1BHKNg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 05:13:36 -0500
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: ext Ohad Ben-Cohen <ohad@wizery.com>, coelho@ti.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl12xx: Allow wl12xx interrupts to wake up the host
References: <1297078254-4664-1-git-send-email-juuso.oikarinen@nokia.com>
	<AANLkTinKyrP2fiE-3+nFeHxvKvg_pn02dLc=t-_+VUJS@mail.gmail.com>
	<1297081781.2064.12.camel@wimaxnb.nmp.nokia.com>
	<AANLkTim2H+s0mM+7HBubEHbYj5O+PRHDkeJefx64zRKx@mail.gmail.com>
	<1297083534.2064.19.camel@wimaxnb.nmp.nokia.com>
	<AANLkTim6J9yizLPcj-ERwVEcp=VXSymXBfFdszHUMp80@mail.gmail.com>
	<1297151826.2064.68.camel@wimaxnb.nmp.nokia.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 08 Feb 2011 12:13:32 +0200
In-Reply-To: <1297151826.2064.68.camel@wimaxnb.nmp.nokia.com> (Juuso Oikarinen's message of "Tue\, 08 Feb 2011 09\:57\:06 +0200")
Message-ID: <87aai696lv.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:

>> > I'm currently trying to find out if this is really needed or not.
>> 
>> Sure, thanks.
>
> They are saying this is needed for OMAP's retention mode too, so AFAIK
> this is needed, not just for suspend.

Why make this change in the driver? Doesn't it mean that all drivers
need to be changed so that they will work in your platform? I would
have expected that this is done automatically somewhere in the core
kernel and without any changes to the driver.

To me platform specific changes in drivers are always problematic.

-- 
Kalle Valo
