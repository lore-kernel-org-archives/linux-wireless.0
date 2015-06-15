Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36914 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbFOUzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 16:55:06 -0400
Date: Mon, 15 Jun 2015 22:54:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Robert Dolca <robert.dolca@intel.com>,
	linux-wireless@vger.kernel.org, kernel@pengutronix.de,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] NFC: PN544: use flags argument of devm_gpiod_get to set
 direction
Message-ID: <20150615205457.GD19996@pengutronix.de> (sfid-20150615_225511_171863_685FD49F)
References: <1432020176-17343-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20150608213911.GG5089@ribalta.mp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20150608213911.GG5089@ribalta.mp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Samuel,

On Mon, Jun 08, 2015 at 11:39:11PM +0200, Samuel Ortiz wrote:
> On Tue, May 19, 2015 at 09:22:56AM +0200, Uwe Kleine-König wrote:
> > Since 39b2bbe3d715 (gpio: add flags argument to gpiod_get*() functions)
> > which appeared in v3.17-rc1, the gpiod_get* functions take an additional
> > parameter that allows to specify direction and initial value for output.
> > 
> > Use this to simplify the driver. Furthermore this is one caller less
> > that stops us making the flags argument to gpiod_get*() mandatory.
> > 
> > While touching this also do some minor coding style fixes.
> > 
> > Fixes: 0a5942c8e148 ("NFC: Add ACPI support for NXP PN544")
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/nfc/pn544/i2c.c | 43 +++++++++++--------------------------------
> >  1 file changed, 11 insertions(+), 32 deletions(-)
> Applied to nfc-next, thanks.
I wonder why nfs isn't included in next. At least this commit doesn't
show up there.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
