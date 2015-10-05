Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49787 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbbJEOjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:39:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>
Subject: Re: [PATCH v6] Add new mac80211 driver mwlwifi.
References: <20456de5ab0b43b69441b19abb282c31@SC-EXCH02.marvell.com>
	<877fo2cn1l.fsf@kamboji.qca.qualcomm.com>
	<4674b8065e1a4bf0b7666c8e58c7947d@SC-EXCH02.marvell.com>
Date: Mon, 05 Oct 2015 17:38:58 +0300
In-Reply-To: <4674b8065e1a4bf0b7666c8e58c7947d@SC-EXCH02.marvell.com> (David
	Lin's message of "Fri, 2 Oct 2015 08:19:49 +0000")
Message-ID: <8737xp4by5.fsf@kamboji.qca.qualcomm.com> (sfid-20151005_163908_901130_095A59AB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Lin <dlin@marvell.com> writes:

>> The device tree bindings need a proper document in
>> Documentation/devicetree/bindings and reviewed by the device tree folks.
>> That might take some time as I suspect having something like regdomain in DT
>> will be problematic, so I recommend to take this out from initial submission
>> and resend later once properly acked by the device tree maintainers.
>>
>
> The code is used to handle mwlwifi proprietary parameters in DTS file.
> Basically it won't be conflicted with any existing bindings. Should I
> still take them out from initial submission?

Yes, please take the device tree code out from the initial submission. I
want the device tree maintainers to review and ack that part and that's
easiest to do separately.

-- 
Kalle Valo
