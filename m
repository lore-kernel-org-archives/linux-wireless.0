Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:4698 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbcANJI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 04:08:29 -0500
Message-ID: <56976588.3060707@broadcom.com> (sfid-20160114_101018_766953_9175AD07)
Date: Thu, 14 Jan 2016 10:08:24 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>, Tony Lindgren <tony@atomide.com>
CC: Igor Grinberg <grinberg@compulab.co.il>,
	Uri Mashiach <uri.mashiach@compulab.co.il>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, <bcousson@baylibre.com>,
	Eliad Peller <eliad@wizery.com>, <devicetree@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] wlcore/wl12xx: spi: add wifi support to cm-t335
References: <1451482533-8624-1-git-send-email-uri.mashiach@compulab.co.il>	<1451482533-8624-4-git-send-email-uri.mashiach@compulab.co.il>	<87io35lq2p.fsf@kamboji.qca.qualcomm.com>	<5695E802.7050909@compulab.co.il> <20160113172712.GI12777@atomide.com> <87wprcbpyr.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87wprcbpyr.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2016 08:05 AM, Kalle Valo wrote:
> Tony Lindgren <tony@atomide.com> writes:
>
>>>>>   arch/arm/boot/dts/am335x-cm-t335.dts | 55 ++++++++++++++++++++++++++++++++++++
>>>>>   1 file changed, 55 insertions(+)
>>>>
>>>> To what tree should this patch go? My wireless-drivers-next tree doesn't
>>>> even have this file.
>>>
>>> Right. It will hit the mainline during this merge window through Tony's and
>>> arm-soc trees.
>>>
>>> Do you think it will be sensible if you take 1/3 and 2/3 patches and Tony
>>> will take the 3/3 (there is no code dependency between first two and the last one),
>>> or we can just wait till arm-soc hits the mainline, so you will have the
>>> needed code?
>>
>> Yeah I'll pick the dts changes separately after the merge window as
>> there is no dependency to the driver changes.
>
> Ok, I'll then take patches 1 and 2 once the merge window opens.

I guess it is semantics, but the merge window is open right now so you 
probably mean to say after the merge window closes, ie. when 4.5-rc1 is 
ready.

Regards,
Arend

