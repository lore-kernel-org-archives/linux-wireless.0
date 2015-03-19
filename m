Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:38755 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbbCSV3r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 17:29:47 -0400
Date: Thu, 19 Mar 2015 14:25:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v7 5/6] ARM: dts: add wl12xx/wl18xx bindings
Message-ID: <20150319212505.GN31346@atomide.com> (sfid-20150319_222952_472198_FD535A40)
References: <1426696710-6891-1-git-send-email-eliad@wizery.com>
 <1426696710-6891-6-git-send-email-eliad@wizery.com>
 <550AD7C1.2030405@gmail.com>
 <CAB3XZEfpD7YkwdU7OJJaNFy=MnYVY3-fOVxkA48Vu01LzU0GFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB3XZEfpD7YkwdU7OJJaNFy=MnYVY3-fOVxkA48Vu01LzU0GFg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Eliad Peller <eliad@wizery.com> [150319 07:43]:
> hi Pontus,
> 
> On Thu, Mar 19, 2015 at 4:05 PM, Pontus Fuchs <pontus.fuchs@gmail.com> wrote:
> > On 2015-03-18 17:38, Eliad Peller wrote:
> >>
> >> Replace all the pdata-quirks for setting wl12xx/wl18xx
> >> platform data with proper DT definitions.
> >>
> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
> >> Acked-by: Javier Martinez Canillas <javier@dowhile0.org>
> >> Acked-by: Enric Balletbo i Serra <eballetbo@gmail.com>
> >> Tested-by: Tony Lindgren <tony@atomide.com>
> >> ---
> >> v7: rebase
> >>
> >>   arch/arm/boot/dts/am335x-evmsk.dts             | 11 ++++
> >>   arch/arm/boot/dts/omap3-cm-t3517.dts           | 10 ++++
> >>   arch/arm/boot/dts/omap3-cm-t3730.dts           | 10 ++++
> >>   arch/arm/boot/dts/omap3-evm-common.dtsi        | 10 ++++
> >>   arch/arm/boot/dts/omap3-igep0020-rev-f.dts     |  9 ++++
> >>   arch/arm/boot/dts/omap3-igep0030-rev-g.dts     |  9 ++++
> >>   arch/arm/boot/dts/omap3-zoom3.dts              | 10 ++++
> >>   arch/arm/boot/dts/omap4-panda-common.dtsi      | 10 ++++
> >
> >
> > Hi Eliad,
> >
> > Tested OK (boot, scan, join, ping) on Pandaboard ES.
> >
> thanks for testing it!

Great. As suggested by Kalle, I'll apply all these into
omap-for-v4.1/wl12xx branch and send a pull request for
the arm-soc probably on Friday if no issues are found.

Regards,

Tony
