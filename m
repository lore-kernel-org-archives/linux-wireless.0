Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:32883 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbbESOzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 10:55:05 -0400
Received: by obblk2 with SMTP id lk2so14172136obb.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 07:55:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432020176-17343-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1432020176-17343-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Tue, 19 May 2015 16:55:04 +0200
Message-ID: <CACRpkdZ2xioK+ys=cPRd23LkKTL_QXA4zg08djSK0mbXDjyCkQ@mail.gmail.com> (sfid-20150519_165510_687199_12F63A45)
Subject: Re: [PATCH] NFC: PN544: use flags argument of devm_gpiod_get to set direction
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Robert Dolca <robert.dolca@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 9:22 AM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:

> Since 39b2bbe3d715 (gpio: add flags argument to gpiod_get*() functions)
> which appeared in v3.17-rc1, the gpiod_get* functions take an additional
> parameter that allows to specify direction and initial value for output.
>
> Use this to simplify the driver. Furthermore this is one caller less
> that stops us making the flags argument to gpiod_get*() mandatory.
>
> While touching this also do some minor coding style fixes.
>
> Fixes: 0a5942c8e148 ("NFC: Add ACPI support for NXP PN544")

As noted on earlier patches: maybe this Fixes: is a bit aggressive.

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Anyways:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
