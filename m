Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43590 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab0IPKpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 06:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <1284632260.23784.10.camel@paavo-desktop>
References: <1284592929-29616-1-git-send-email-ohad@wizery.com>
 <1284592929-29616-2-git-send-email-ohad@wizery.com> <1284632260.23784.10.camel@paavo-desktop>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 16 Sep 2010 12:45:31 +0200
Message-ID: <AANLkTikYd+TojQC-R+Vrdou6KSRwFNczBeTnsX7eTDn4@mail.gmail.com>
Subject: Re: [PATCH v6 1/7] wl12xx: make wl12xx.h common to both spi and sdio
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 12:17 PM, Teemu Paasikivi
<ext-teemu.3.paasikivi@nokia.com> wrote:
> On Thu, 2010-09-16 at 01:22 +0200, ext Ohad Ben-Cohen wrote:
>> Move wl12xx.h outside of the spi-specific location,
>> so it can be shared with both spi and sdio solutions.
>>
>> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
>> ---
> Hi,
>
>
> wl12xx.h seems to be included also in
> arch/arm/mach-omap2/board-rx51-peripherals.c, so that should be changed
> too.

Thanks for catching this, I now see there are several spi/wl12xx.h
users (rx51, omap3pandora and MAINTAINERS).

An update is coming.

>
>
> Best Regards,
>
> Teemu Paasikivi
>
>
>
