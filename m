Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41394 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbbI2JEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 05:04:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Chor Teck Law <ctlaw@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	David Lin <dlin@marvell.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH] Add new mac80211 driver mwlwifi.
References: <6d9f23a4a8bf4315b0c7630a9a1c37ad@SC-EXCH02.marvell.com>
	<1433598191.2467.65.camel@sipsolutions.net>
	<877fo3he8y.fsf@kamboji.qca.qualcomm.com>
	<9fcd82c278ea47cb915798ffc7bdcb0b@SC-EXCH03.marvell.com>
Date: Tue, 29 Sep 2015 12:04:47 +0300
In-Reply-To: <9fcd82c278ea47cb915798ffc7bdcb0b@SC-EXCH03.marvell.com> (Chor
	Teck Law's message of "Fri, 11 Sep 2015 14:03:08 +0000")
Message-ID: <87a8s57g0g.fsf@kamboji.qca.qualcomm.com> (sfid-20150929_110459_381231_3DF2E287)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chor Teck Law <ctlaw@marvell.com> writes:

>> > Could consider moving all the Marvell drivers
>> > into one directory, but not really necessary I guess.
>> 
>> Actually I would want to start adding vendor directories for wireless
>> drivers, just like drivers/net/ethernet has, to cleanup the directory
>> structure. So for example this driver we would have
>> drivers/net/wireless/marvell/mwlwifi and later we would start moving
>> existing drivers to vendor drivers as well. Thoughts?
>> 
>
> Yes, we are ok with this folder hierarchy change. Let us know how we
> can help. Should we start with this new folder now or wait for more
> feedbacks?

Yeah, in the next version please use the new folder hierarchy for
mwlwifi.

-- 
Kalle Valo
