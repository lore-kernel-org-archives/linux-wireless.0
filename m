Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:39864 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbbCYVqy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 17:46:54 -0400
Date: Wed, 25 Mar 2015 14:42:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eliad Peller <eliad@wizery.com>,
	Pontus Fuchs <pontus.fuchs@gmail.com>,
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
Message-ID: <20150325214230.GB31346@atomide.com> (sfid-20150325_224658_753474_7417949B)
References: <1426696710-6891-1-git-send-email-eliad@wizery.com>
 <1426696710-6891-6-git-send-email-eliad@wizery.com>
 <550AD7C1.2030405@gmail.com>
 <CAB3XZEfpD7YkwdU7OJJaNFy=MnYVY3-fOVxkA48Vu01LzU0GFg@mail.gmail.com>
 <20150319212505.GN31346@atomide.com>
 <87h9tgi4sg.fsf@kamboji.qca.qualcomm.com>
 <20150320153357.GT31346@atomide.com>
 <87bnjnfz1t.fsf@kamboji.qca.qualcomm.com>
 <20150320162138.GU31346@atomide.com>
 <87twxce2oh.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87twxce2oh.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Kalle Valo <kvalo@codeaurora.org> [150322 21:52]:
> Tony Lindgren <tony@atomide.com> writes:
> 
> >> After John "retired" we actually have two set of trees now: mac80211
> >> maintained by Johannes and wireless-drivers maintained by me. I haven't
> >> pulled anything from your tree and I'm 100% sure Johannes hasn't either.
> >> So green light from me.
> >
> > OK, I'll set up the new branch then. I take your ack is for the
> > whole series? If it's just for the $subject patch, please let
> > me know.
> 
> It was for the whole series.

OK thanks, I've sent of the pull request for arm-soc for this series
as "[GIT PULL] wireless wl12xx and omap device tree changes for v4.1".

Regards,

Tony
