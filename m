Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:36824 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760951Ab3LIJit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 04:38:49 -0500
Received: by mail-oa0-f49.google.com with SMTP id i4so3542634oah.36
        for <linux-wireless@vger.kernel.org>; Mon, 09 Dec 2013 01:38:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131209041821.GC14878@us.netrek.org>
References: <20131203202607.0b445195@kemnade.info> <1386167786.19448.4.camel@dcbw.foobar.com>
 <CA+E=qVdY4M=bnX=pqMiMirhQ_BRg6Uc6K9Xkzvf328BaByUF1g@mail.gmail.com> <20131209041821.GC14878@us.netrek.org>
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Mon, 9 Dec 2013 12:38:28 +0300
Message-ID: <CA+E=qVd_F_=z5Vb2jan-nNVmizQznOiR=98CPHQevMxbnxGJiA@mail.gmail.com> (sfid-20131209_103858_456183_856DEA05)
Subject: Re: status of libertas_tf + sdio?
To: James Cameron <quozl@laptop.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 9, 2013 at 7:18 AM, James Cameron <quozl@laptop.org> wrote:
> On Fri, Dec 06, 2013 at 01:40:00PM +0300, Vasily Khoruzhick wrote:
>> Out of curiosity,
>>
>> Does anyone know if it's possible to get thin firmware for 8686 with
>> SPI interface?
>
> What happens when you try?

How? There's no tf available for 8686 with SPI interface.

> How are you downloading firmware over SPI?

See drivers/net/wireless/libertas/if_spi.c, but it's for fat firmware

> I'm not aware of a second stage firmware download helper specific to
> the SPI mode.

What's a second stage firmware download helper?

> I think it is not possible without firmware engineering.

Yeah, just hoped that Marvell already did it. It's a pity that
firmware source code isn't available :(

Regards
Vasily

>
> --
> James Cameron
> http://quozl.linux.org.au/
