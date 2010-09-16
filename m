Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:61311 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0IPUCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 16:02:05 -0400
Subject: Re: [PATCH v6 01/17] wl12xx: make wl12xx.h common to both spi and
 sdio
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>,
	"Paasikivi Teemu.3 (EXT-Ixonos/Tampere)"
	<ext-teemu.3.paasikivi@nokia.com>
In-Reply-To: <AANLkTinQ3EVOTjfnOy7EXP==b=tpSicDdokBAZ67Lc7O@mail.gmail.com>
References: <AANLkTikYd+TojQC-R+Vrdou6KSRwFNczBeTnsX7eTDn4@mail.gmail.com>
	 <1284635762-12335-1-git-send-email-ohad@wizery.com>
	 <1284662139.8951.7.camel@powerslave>
	 <AANLkTinQ3EVOTjfnOy7EXP==b=tpSicDdokBAZ67Lc7O@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 23:00:59 +0300
Message-ID: <1284667259.8951.75.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-16 at 21:56 +0200, ext Ohad Ben-Cohen wrote:
> On Thu, Sep 16, 2010 at 8:35 PM, Luciano Coelho
> <luciano.coelho@nokia.com> wrote:
> > Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
> >
> > I just wonder why the wl12xx.h move wasn't detected as a rename.  Did
> > you forget to use the -M option in format-patch?
> 
> I thought it's because I stripped the SPI_ from the
> #ifndef _LINUX_SPI_WL12XX_H, but it should be smarter than that.
> Probably the -M.

Yes, it is smarter than that.  With small changes like this, -M will
still show it as a rename and show the diff instead of the whole file
-ed and +ed back ;)

-- 
Cheers,
Luca.

