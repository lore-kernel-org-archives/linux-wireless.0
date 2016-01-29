Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41468 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbcA2JLG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 04:11:06 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v4,1/3] wlcore/wl12xx: spi: add power operation function
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1451482533-8624-2-git-send-email-uri.mashiach@compulab.co.il>
To: Uri Mashiach <uri.mashiach@compulab.co.il>
Cc: Rob Herring <robh+dt@kernel.org>, Tony Lindgren <tony@atomide.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Uri Mashiach <uri.mashiach@compulab.co.il>
Message-Id: <20160129091105.668A2604A2@smtp.codeaurora.org> (sfid-20160129_101119_251090_46EE5187)
Date: Fri, 29 Jan 2016 09:11:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The power function uses a consumer regulator access to update the WiFi
> enable GPIO value.
> 
> Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
> Tested-By: Sebastian Reichel <sre@kernel.org>
> Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Acked-by: Igor Grinberg <grinberg@compulab.co.il>

Thanks, 2 patches applied to wireless-drivers-next.git:

4c1ce07bcf62 wlcore/wl12xx: spi: add power operation function
04654c386145 wlcore/wl12xx: spi: add device tree support

Kalle Valo
