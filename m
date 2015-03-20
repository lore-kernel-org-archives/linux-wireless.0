Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48542 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbCTGDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 02:03:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Eliad Peller <eliad@wizery.com>,
	Pontus Fuchs <pontus.fuchs@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel\@lists.infradead.org"
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
References: <1426696710-6891-1-git-send-email-eliad@wizery.com>
	<1426696710-6891-6-git-send-email-eliad@wizery.com>
	<550AD7C1.2030405@gmail.com>
	<CAB3XZEfpD7YkwdU7OJJaNFy=MnYVY3-fOVxkA48Vu01LzU0GFg@mail.gmail.com>
	<20150319212505.GN31346@atomide.com>
Date: Fri, 20 Mar 2015 08:03:43 +0200
In-Reply-To: <20150319212505.GN31346@atomide.com> (Tony Lindgren's message of
	"Thu, 19 Mar 2015 14:25:06 -0700")
Message-ID: <87h9tgi4sg.fsf@kamboji.qca.qualcomm.com> (sfid-20150320_070359_044926_AF1B43AD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> writes:

>> > Tested OK (boot, scan, join, ping) on Pandaboard ES.
>> >
>> thanks for testing it!
>
> Great. As suggested by Kalle, I'll apply all these into
> omap-for-v4.1/wl12xx branch and send a pull request for
> the arm-soc probably on Friday if no issues are found.

Great, thank you. Just in case you want this:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
