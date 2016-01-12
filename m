Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758791AbcALLXE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 06:23:04 -0500
Subject: Re: [PATCH v4 1/3] wlcore/wl12xx: spi: add power operation function
To: Sebastian Reichel <sre@kernel.org>,
	Uri Mashiach <uri.mashiach@compulab.co.il>
References: <1451482533-8624-1-git-send-email-uri.mashiach@compulab.co.il>
 <1451482533-8624-2-git-send-email-uri.mashiach@compulab.co.il>
 <20160109025356.GA3644@earth>
CC: Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, <bcousson@baylibre.com>,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, <devicetree@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
From: Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <5694E1A4.20303@ti.com> (sfid-20160112_122311_289565_3FD1E8DF)
Date: Tue, 12 Jan 2016 13:21:08 +0200
MIME-Version: 1.0
In-Reply-To: <20160109025356.GA3644@earth>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2016 04:53 AM, Sebastian Reichel wrote:
> Hi,
>
> On Wed, Dec 30, 2015 at 03:35:31PM +0200, Uri Mashiach wrote:
>> The power function uses a consumer regulator access to update the WiFi
>> enable GPIO value.
>>
>> Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
>
> [On Nokia N950]
> Tested-By: Sebastian Reichel <sre@kernel.org>


Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

Thanks.
-- 
regards,
-grygorii
