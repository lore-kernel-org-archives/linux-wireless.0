Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:32797 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbbG2HiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 03:38:06 -0400
Received: by obdeg2 with SMTP id eg2so1312012obd.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2015 00:38:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55B80F21.3090803@gmail.com>
References: <55B80F21.3090803@gmail.com>
Date: Wed, 29 Jul 2015 09:38:04 +0200
Message-ID: <CACRpkdYTJWS7mbw_OJtW78ThQ6jZ7aSoM5uR1SLihV4L+E5vtQ@mail.gmail.com> (sfid-20150729_093811_532663_5B3258D8)
Subject: Re: Driver for Mediatek MT7630E
From: Linus Walleij <linus.walleij@linaro.org>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Jakub Kicinski <kubakici@wp.pl>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2015 at 1:24 AM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> Linus Walleij wrote:
>
>> Did anything ever happen to this?
>>
>> My daughter has this device in her laptop it seems, sigh.
>>
>> I might start fiddling with it unless someone else is already
>> doing it.
>
> Jakub Kicinski was working on it at: https://github.com/kuba-moo/mt7630e

Ah yeah that is what I have running. It's a fork of rt2x00 so it's
missing all fixes since 3.11 or so, just a question of when this
becomes unsupportable.

This code is a complete mashup of Linux and duct-taped Windows
NDIS-based driver code, my eyes are bleeding from looking at it.

The defines etc patched in have obvious gaps due to other unsupported
chips such as MT7601u I suspect. I guess it's necessary to also
look at this in order to not screw things up for 7601.
https://github.com/porjo/mt7601

Yours,
Linus Walleij
