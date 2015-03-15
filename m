Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:62338 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbbCOMJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 08:09:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Eliad Peller <eliad@wizery.com>, Tony Lindgren <tony@atomide.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Rob Herring <robh+dt@kernel.org>,
	=?ISO-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
	Kumar Gala <galak@codeaurora.org>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Luciano Coelho <luca@coelho.fi>
Subject: Re: [PATCH v6 2/6] wl12xx: use frequency instead of enumerations for pdata clocks
Date: Sun, 15 Mar 2015 13:08:54 +0100
Message-ID: <3103538.jZ037SODdT@wuerfel> (sfid-20150315_130915_508235_5ACCCA62)
In-Reply-To: <CAB3XZEcOytqpJ4pWoemLS3d+DCeA8C75MencDfGn_vhfEYrduw@mail.gmail.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com> <20150313150047.GI5264@atomide.com> <CAB3XZEcOytqpJ4pWoemLS3d+DCeA8C75MencDfGn_vhfEYrduw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 15 March 2015 10:43:35 Eliad Peller wrote:
> 
> > The other option would be to have the whole series in a immutable
> > branch against v3.0-rc1 that can be merged into both wirelss tree
> > and omap tree.
> >
> i think that could be easier.
> 
> or maybe you can just take them all through the omap tree? the wlcore
> tree is not under active development, so i don't expect conflicts
> there.

I'm fine with both these approaches.

	Arnd
