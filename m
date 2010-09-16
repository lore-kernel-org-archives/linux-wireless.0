Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50200 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0IPT5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 15:57:18 -0400
MIME-Version: 1.0
In-Reply-To: <1284662139.8951.7.camel@powerslave>
References: <AANLkTikYd+TojQC-R+Vrdou6KSRwFNczBeTnsX7eTDn4@mail.gmail.com>
 <1284635762-12335-1-git-send-email-ohad@wizery.com> <1284662139.8951.7.camel@powerslave>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 16 Sep 2010 21:56:57 +0200
Message-ID: <AANLkTinQ3EVOTjfnOy7EXP==b=tpSicDdokBAZ67Lc7O@mail.gmail.com>
Subject: Re: [PATCH v6 01/17] wl12xx: make wl12xx.h common to both spi and sdio
To: Luciano Coelho <luciano.coelho@nokia.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 8:35 PM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
> Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
>
> I just wonder why the wl12xx.h move wasn't detected as a rename.  Did
> you forget to use the -M option in format-patch?

I thought it's because I stripped the SPI_ from the
#ifndef _LINUX_SPI_WL12XX_H, but it should be smarter than that.
Probably the -M.

Thanks,
Ohad.


>
> --
> Cheers,
> Luca.
>
>
