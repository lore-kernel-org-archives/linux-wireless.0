Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:58050 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934774AbcA0SlE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 13:41:04 -0500
Date: Wed, 27 Jan 2016 10:41:01 -0800
From: Tony Lindgren <tony@atomide.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Uri Mashiach <uri.mashiach@compulab.co.il>,
	Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 3/3] wlcore/wl12xx: spi: add wifi support to cm-t335
Message-ID: <20160127184101.GU19432@atomide.com> (sfid-20160127_194111_102128_D0785FA9)
References: <1451482533-8624-1-git-send-email-uri.mashiach@compulab.co.il>
 <1451482533-8624-4-git-send-email-uri.mashiach@compulab.co.il>
 <5695EA06.5020801@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5695EA06.5020801@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Igor Grinberg <grinberg@compulab.co.il> [160112 22:09]:
> 
> 
> On 12/30/15 15:35, Uri Mashiach wrote:
> > Device tree modifications:
> > - Pinmux for SPI0 and WiFi GPIOs.
> > - SPI0 node with wlcore as a child node.
> > 
> > Cc: Tony Lindgren <tony@atomide.com>
> > Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
> 
> Acked-by: Igor Grinberg <grinberg@compulab.co.il>

Applying into omap-for-v4.6/dt thanks.

Tony
