Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:28951 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab0IPKSy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 06:18:54 -0400
Subject: Re: [PATCH v6 1/7] wl12xx: make wl12xx.h common to both spi and
 sdio
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <1284592929-29616-2-git-send-email-ohad@wizery.com>
References: <1284592929-29616-1-git-send-email-ohad@wizery.com>
	 <1284592929-29616-2-git-send-email-ohad@wizery.com>
Content-Type: text/plain
Date: Thu, 16 Sep 2010 13:17:40 +0300
Message-Id: <1284632260.23784.10.camel@paavo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-16 at 01:22 +0200, ext Ohad Ben-Cohen wrote:
> Move wl12xx.h outside of the spi-specific location,
> so it can be shared with both spi and sdio solutions.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
Hi,


wl12xx.h seems to be included also in 
arch/arm/mach-omap2/board-rx51-peripherals.c, so that should be changed
too.


Best Regards,

Teemu Paasikivi


