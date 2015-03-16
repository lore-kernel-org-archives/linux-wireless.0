Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:37813 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932962AbbCPVGd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 17:06:33 -0400
Date: Mon, 16 Mar 2015 14:01:43 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	Eliad Peller <eliad@wizery.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Rob Herring <robh+dt@kernel.org>,
	=?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Kumar Gala <galak@codeaurora.org>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Luciano Coelho <luca@coelho.fi>
Subject: Re: [PATCH v6 6/6] wlcore: remove wl12xx_platform_data
Message-ID: <20150316210143.GF12397@atomide.com> (sfid-20150316_220645_027380_6EC9DEF2)
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
 <2070859.WcMooC33YH@wuerfel>
 <20150316152939.GP5264@atomide.com>
 <201503162158.50587@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201503162158.50587@pali>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Pali Rohár <pali.rohar@gmail.com> [150316 13:59]:
> On Monday 16 March 2015 16:29:39 Tony Lindgren wrote:
> > I believe the last pending issues is the support for
> > ATAG_REVISION in device tree mode as posted by Pali.
> > 
> 
> No. In DT boot there is missing /proc/atags file (readable by 
> userspace processes).

Oh OK thanks for the update.

> And also broken AES/SHA/MD5 support. Fix for crypto DT stuff
> I already sent.

But this is not a regression in mainline with legacy boot vs
device tree based booting, right? Sounds like it never worked
in the mainline or am thinking of some other set of patches?

Regards,

Tony
