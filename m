Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:49268 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab0IPUrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 16:47:05 -0400
Date: Thu, 16 Sep 2010 13:46:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>,
	"Paasikivi Teemu.3 (EXT-Ixonos/Tampere)"
	<ext-teemu.3.paasikivi@nokia.com>
Subject: Re: [PATCH v6 01/17] wl12xx: make wl12xx.h common to both spi and
 sdio
Message-ID: <20100916204648.GO29610@atomide.com>
References: <AANLkTikYd+TojQC-R+Vrdou6KSRwFNczBeTnsX7eTDn4@mail.gmail.com>
 <1284635762-12335-1-git-send-email-ohad@wizery.com>
 <1284662139.8951.7.camel@powerslave>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1284662139.8951.7.camel@powerslave>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Luciano Coelho <luciano.coelho@nokia.com> [100916 11:28]:
> On Thu, 2010-09-16 at 13:16 +0200, ext Ohad Ben-Cohen wrote:
> > Move wl12xx.h outside of the spi-specific location,
> > so it can be shared with both spi and sdio solutions.
> > 
> > Update all users of spi/wl12xx.h accordingly
> > 
> > Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> > ---
> 
> Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

Looks good to me too:

Acked-by: Tony Lindgren <tony@atomide.com>
