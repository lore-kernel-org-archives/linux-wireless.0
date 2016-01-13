Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:35054 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbcAMGJO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 01:09:14 -0500
Subject: Re: [PATCH v4 3/3] wlcore/wl12xx: spi: add wifi support to cm-t335
To: Uri Mashiach <uri.mashiach@compulab.co.il>,
	Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>
References: <1451482533-8624-1-git-send-email-uri.mashiach@compulab.co.il>
 <1451482533-8624-4-git-send-email-uri.mashiach@compulab.co.il>
Cc: Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: Igor Grinberg <grinberg@compulab.co.il>
Message-ID: <5695EA06.5020801@compulab.co.il> (sfid-20160113_070919_518179_3496EC44)
Date: Wed, 13 Jan 2016 08:09:10 +0200
MIME-Version: 1.0
In-Reply-To: <1451482533-8624-4-git-send-email-uri.mashiach@compulab.co.il>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/30/15 15:35, Uri Mashiach wrote:
> Device tree modifications:
> - Pinmux for SPI0 and WiFi GPIOs.
> - SPI0 node with wlcore as a child node.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>

Acked-by: Igor Grinberg <grinberg@compulab.co.il>

-- 
Regards,
Igor.
