Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:51235 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbbLWPgf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 10:36:35 -0500
Date: Wed, 23 Dec 2015 07:36:31 -0800
From: Tony Lindgren <tony@atomide.com>
To: Uri Mashiach <uri.mashiach@compulab.co.il>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] wlcore/wl12xx: spi: add device tree support
Message-ID: <20151223153630.GK2793@atomide.com> (sfid-20151223_163641_195786_C4D63862)
References: <1450859744-9948-1-git-send-email-uri.mashiach@compulab.co.il>
 <1450859744-9948-3-git-send-email-uri.mashiach@compulab.co.il>
 <567A76B5.70605@ti.com>
 <567AB1CB.1050203@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <567AB1CB.1050203@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Uri Mashiach <uri.mashiach@compulab.co.il> [151223 06:38]:
> On 12/23/2015 12:25 PM, Grygorii Strashko wrote:
> 
> >>+                        that services interrupts for this device
> >>+- vwlan-supply :        Point the node of the regulator that controls the wl1271 chip WLAN_EN pin
> >
> >Pls, use gpio if this is required just to toggle WLAN_EN pin.
> >
> >[ti,] power-gpio or en-gpio
> >
> >
> 
> The controller's power might need toggling in some board implementation.
> Maybe GPIO and regulator should be implemented?

Yes a regulator for wlcore is best here because to properly control it
and the wait needed.

Regards,

Tony
