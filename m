Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:38945 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbbCTPig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 11:38:36 -0400
Date: Fri, 20 Mar 2015 08:33:57 -0700
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
Message-ID: <20150320153357.GT31346@atomide.com> (sfid-20150320_163843_940517_65468E8C)
References: <1426696710-6891-1-git-send-email-eliad@wizery.com>
 <1426696710-6891-6-git-send-email-eliad@wizery.com>
 <550AD7C1.2030405@gmail.com>
 <CAB3XZEfpD7YkwdU7OJJaNFy=MnYVY3-fOVxkA48Vu01LzU0GFg@mail.gmail.com>
 <20150319212505.GN31346@atomide.com>
 <87h9tgi4sg.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87h9tgi4sg.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Kalle Valo <kvalo@codeaurora.org> [150319 23:04]:
> Tony Lindgren <tony@atomide.com> writes:
> 
> >> > Tested OK (boot, scan, join, ping) on Pandaboard ES.
> >> >
> >> thanks for testing it!
> >
> > Great. As suggested by Kalle, I'll apply all these into
> > omap-for-v4.1/wl12xx branch and send a pull request for
> > the arm-soc probably on Friday if no issues are found.
> 
> Great, thank you. Just in case you want this:
> 
> Acked-by: Kalle Valo <kvalo@codeaurora.org>

Thanks, I can push out a new branch omap-for-v4.1/wl12xx-v2
with your acks assuming you or somebody else have not
merged the existing omap-for-v4.1/wl12xx branch yet into the
wireless tree?

In that case I can scrap omap-for-v4.1/wl12xx and then will
reply with a commit that we can consider immutable that can
be merged into various trees as needed in case of merge
conflicts.

But I'll wait for your confirmation first :)

Regards,

Tony
