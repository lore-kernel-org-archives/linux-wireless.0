Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63740 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1BGMjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 07:39:09 -0500
Received: by iyj8 with SMTP id 8so2077693iyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Feb 2011 04:39:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297081781.2064.12.camel@wimaxnb.nmp.nokia.com>
References: <1297078254-4664-1-git-send-email-juuso.oikarinen@nokia.com>
 <AANLkTinKyrP2fiE-3+nFeHxvKvg_pn02dLc=t-_+VUJS@mail.gmail.com> <1297081781.2064.12.camel@wimaxnb.nmp.nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 7 Feb 2011 14:38:46 +0200
Message-ID: <AANLkTim2H+s0mM+7HBubEHbYj5O+PRHDkeJefx64zRKx@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: Allow wl12xx interrupts to wake up the host
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 7, 2011 at 2:29 PM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> On Mon, 2011-02-07 at 14:09 +0200, ext Ohad Ben-Cohen wrote:
>> On Mon, Feb 7, 2011 at 1:30 PM, <juuso.oikarinen@nokia.com> wrote:
>> >
>> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>> >
>> > Currently the wl12xx interrupts are not configured to wake up the host, which
>> > leads to reduced performance.
>>
>> Can you elaborate what do you mean ?
>>
>> Today the chip is powered off at system suspend, so it won't trigger
>> any interrupts anyway.
>>
>> When additional suspend modes will be introduced (e.g. WoWL) this will
>> be needed of course.
>
> These are not just for suspend, AFAIK, but apply also to power saving
> states.

What power states do you mean ? do you mean the cpuidle path ? I don't
think it's related.

Can you please describe what was the reduced performance that this
solved for you ? performance is a hot topic for us now :)

Thanks,
Ohad.


 Or do you know better?
>
> -Juuso
>
>> Thanks,
>> Ohad.
>
>
>
