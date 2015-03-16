Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56518 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbbCPGuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 02:50:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Eliad Peller <eliad@wizery.com>,
	Tony Lindgren <tony@atomide.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Rob Herring <robh+dt@kernel.org>,
	=?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Kumar Gala <galak@codeaurora.org>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	"linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Luciano Coelho <luca@coelho.fi>
Subject: Re: [PATCH v6 2/6] wl12xx: use frequency instead of enumerations for pdata clocks
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
	<20150313150047.GI5264@atomide.com>
	<CAB3XZEcOytqpJ4pWoemLS3d+DCeA8C75MencDfGn_vhfEYrduw@mail.gmail.com>
	<3103538.jZ037SODdT@wuerfel>
Date: Mon, 16 Mar 2015 08:50:31 +0200
In-Reply-To: <3103538.jZ037SODdT@wuerfel> (Arnd Bergmann's message of "Sun, 15
	Mar 2015 13:08:54 +0100")
Message-ID: <87lhixphag.fsf@kamboji.qca.qualcomm.com> (sfid-20150316_075046_289058_33CF35BE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> On Sunday 15 March 2015 10:43:35 Eliad Peller wrote:
>> 
>> > The other option would be to have the whole series in a immutable
>> > branch against v3.0-rc1 that can be merged into both wirelss tree
>> > and omap tree.
>> >
>> i think that could be easier.
>> 
>> or maybe you can just take them all through the omap tree? the wlcore
>> tree is not under active development, so i don't expect conflicts
>> there.
>
> I'm fine with both these approaches.

I prefer these going through the omap tree. Like Eliad said,
drivers/net/wireless/ti does not get that many changes nowadays so the
chances of this patchset conflicting with something is very small.

-- 
Kalle Valo
