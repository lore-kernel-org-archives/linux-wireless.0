Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:32804 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbcAMGDS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 01:03:18 -0500
Subject: Re: [PATCH v4 1/3] wlcore/wl12xx: spi: add power operation function
To: Uri Mashiach <uri.mashiach@compulab.co.il>,
	Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>
References: <1451482533-8624-1-git-send-email-uri.mashiach@compulab.co.il>
 <1451482533-8624-2-git-send-email-uri.mashiach@compulab.co.il>
Cc: Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: Igor Grinberg <grinberg@compulab.co.il>
Message-ID: <5695E8A2.403@compulab.co.il> (sfid-20160113_070324_754359_00D3E937)
Date: Wed, 13 Jan 2016 08:03:14 +0200
MIME-Version: 1.0
In-Reply-To: <1451482533-8624-2-git-send-email-uri.mashiach@compulab.co.il>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/30/15 15:35, Uri Mashiach wrote:
> The power function uses a consumer regulator access to update the WiFi
> enable GPIO value.
> 
> Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>

Acked-by: Igor Grinberg <grinberg@compulab.co.il>


-- 
Regards,
Igor.
