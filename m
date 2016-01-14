Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47311 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbcANJLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 04:11:42 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Tony Lindgren <tony@atomide.com>,
	Igor Grinberg <grinberg@compulab.co.il>,
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
References: <1451482533-8624-1-git-send-email-uri.mashiach@compulab.co.il>
	<1451482533-8624-4-git-send-email-uri.mashiach@compulab.co.il>
	<87io35lq2p.fsf@kamboji.qca.qualcomm.com>
	<5695E802.7050909@compulab.co.il> <20160113172712.GI12777@atomide.com>
	<87wprcbpyr.fsf@kamboji.qca.qualcomm.com>
	<56976588.3060707@broadcom.com>
Date: Thu, 14 Jan 2016 11:11:30 +0200
In-Reply-To: <56976588.3060707@broadcom.com> (Arend van Spriel's message of
	"Thu, 14 Jan 2016 10:08:24 +0100")
Message-ID: <87y4bsa5kt.fsf@kamboji.qca.qualcomm.com> (sfid-20160114_101149_844243_BF157CD1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 01/14/2016 08:05 AM, Kalle Valo wrote:
>> Tony Lindgren <tony@atomide.com> writes:
>>
>>> Yeah I'll pick the dts changes separately after the merge window as
>>> there is no dependency to the driver changes.
>>
>> Ok, I'll then take patches 1 and 2 once the merge window opens.
>
> I guess it is semantics, but the merge window is open right now so you
> probably mean to say after the merge window closes, ie. when 4.5-rc1
> is ready.

Exactly. Sorry, I suck in multitasking :)

-- 
Kalle Valo
