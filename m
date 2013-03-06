Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62655 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3CFUcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 15:32:25 -0500
Received: by mail-wg0-f46.google.com with SMTP id fg15so7986991wgb.25
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2013 12:32:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87boawaamw.fsf@purkki.adurom.net>
References: <CAEk6VBHnWn_KF0TJ_vojuOhWFhR6TncAok+B9mqgGzAdC5DzVg@mail.gmail.com>
	<20790.56369.998911.884240@gargle.gargle.HOWL>
	<CAEk6VBHTWn8CX7SKNVQz+T+Wqwe9Na=32Lz=+xOdqncNZFhhkQ@mail.gmail.com>
	<87boawaamw.fsf@purkki.adurom.net>
Date: Thu, 7 Mar 2013 04:32:24 +0800
Message-ID: <CAEk6VBHTNMgmDj2fFwtzDMJevcv9p3rDzG+JmCyeZKGtgnh86g@mail.gmail.com> (sfid-20130306_213233_529908_817EFE84)
Subject: Re: [ath9k] Recent driver versions break compatibility with AR9285
 for me
From: Nick Thomas <nhomas@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle,

I'll try those things!

Nick

On Wed, Mar 6, 2013 at 10:03 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Nick Thomas <nhomas@gmail.com> writes:
>
>> The latter iwconfig readout is from an old kernel version (3.2.39),
>> where the card does indeed work. What I wish to report is that in a
>> more recent kernel version (3.7.10), the card doesn't work (iwconfig
>> says "no wireless extensions"). It's not a problem for me (I'm happily
>> using the old kernel), but I thought it was worth reporting.
>
> What if 3.7.10 kernel just doesn't have the old wireless extensions
> (CONFIG_CFG80211_WEXT) enabled? Did you try iw which uses nl80211?
>
> http://wireless.kernel.org/en/users/Documentation/iw
>
> --
> Kalle Valo
