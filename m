Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46267 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbbL3Qag (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 11:30:36 -0500
Date: Wed, 30 Dec 2015 10:30:31 -0600
From: Rob Herring <robh@kernel.org>
To: Uri Mashiach <uri.mashiach@compulab.co.il>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Tony Lindgren <tony@atomide.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] wlcore/wl12xx: spi: add device tree support
Message-ID: <20151230163031.GA24863@rob-hp-laptop> (sfid-20151230_173042_713323_D93DE8F1)
References: <1450859744-9948-1-git-send-email-uri.mashiach@compulab.co.il>
 <1450859744-9948-3-git-send-email-uri.mashiach@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450859744-9948-3-git-send-email-uri.mashiach@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 23, 2015 at 10:35:43AM +0200, Uri Mashiach wrote:
> Add DT support for the wl1271 SPI WiFi.
> 
> Add documentation file for the wl1271 SPI WiFi.
> 
> Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
> Acked-by: Igor Grinberg <grinberg@compulab.co.il>
> ---
>  .../bindings/net/wireless/ti,wlcore,spi.txt        | 35 +++++++++++

For the binding:

Acked-by: Rob Herring <robh@kernel.org>
