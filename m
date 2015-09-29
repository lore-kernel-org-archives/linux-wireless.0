Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41278 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbbI2JDV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 05:03:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Chor Teck Law <ctlaw@marvell.com>
Cc: David Lin <dlin@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
	<1436455659.36587.131.camel@sakura.staff.proxad.net>
	<87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
	<20150804220956.GA28583@sakura.staff.proxad.net>
	<1d5d24295c1c45ec856c908c60dab13b@SC-EXCH03.marvell.com>
	<87vbbmeasb.fsf@kamboji.qca.qualcomm.com>
	<5743c7447a834df1bf719dfa3444e9cd@SC-EXCH03.marvell.com>
Date: Tue, 29 Sep 2015 12:03:14 +0300
In-Reply-To: <5743c7447a834df1bf719dfa3444e9cd@SC-EXCH03.marvell.com> (Chor
	Teck Law's message of "Fri, 11 Sep 2015 13:43:37 +0000")
Message-ID: <87eghh7g30.fsf@kamboji.qca.qualcomm.com> (sfid-20150929_110327_063803_B3F601BE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chor Teck Law <ctlaw@marvell.com> writes:

>> You have named the new driver as mwlwifi, which is a really generic
>> name. Does that imply that mwlwifi will start supporting more Marvell
>> devices in the future? 
>
> Yes, that is the plan on same generation of 11ac chipset that support
> host-based mac80211.
>
>> Or will be in the situation that you fork the
>> driver again and we end up having mwlwifi2, mwlwifi3 and so on?
>> 
>
> We do intend to add interface HAL spec version to mwlwifi in case the
> lower HAL becomes unavoidably changed in future, so that we can
> continue to maintain mwlwifi.

Very good.

> But for different generation of future chipsets/new technology, when
> the hardware no longer permit us to use same driver, we will have to
> re-evaluate our options. We cannot guarantee something way out into
> the future.

Yeah, that's understandable. But the community really dislikes having
duplicated code/functionality, so please keep this in mind.

If you can submit the next version soon we could try to get this driver
to 4.4. We have few more weeks.

-- 
Kalle Valo
