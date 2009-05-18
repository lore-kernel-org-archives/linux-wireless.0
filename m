Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:61054 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZERSjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 14:39:53 -0400
Received: by bwz22 with SMTP id 22so3382246bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 11:39:53 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [WIP PATCH] sdio support for wl12xx
References: <20090518180957.GD2580@hash.localnet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 18 May 2009 21:39:51 +0300
In-Reply-To: <20090518180957.GD2580@hash.localnet> (Bob Copeland's message of "Mon\, 18 May 2009 14\:09\:57 -0400")
Message-ID: <874ovib6h4.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> Hi all,

Hi Bob,

> Here's a VERY rough patch containing SDIO support for wl12xx, not
> yet for applying.  However, it does load (with the proper setup code)
> on my Android dev phone, chip probe works, and probably the rest too,
> though I didn't get that far.

Very cool!

>  This also splits out spi driver so we have wl12xx.ko (core) and
> wl12xx_spi/_sdio.

For the upcoming 1271 support this might create some problems, but let's
worry that later.

> A big thanks to the Nokia engineers for making this as easy as inserting
> an io ops structure and shuffling some code around.  The actual SDIO
> read/write bits are largely identical to TI/Google's own GPLed driver,
> though I plan to rework them a bit before submitting this (see below).

>From a quick look this looks good to me, having separate io.c was a good
choice. I won't comment on the details yet because this is early stages
still.

Thanks a lot for doing this!

-- 
Kalle Valo
