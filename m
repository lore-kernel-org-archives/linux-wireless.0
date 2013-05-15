Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55610 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3EOQIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 12:08:18 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: Joe Perches <joe@perches.com>, <linux-wireless@vger.kernel.org>,
	<ath10k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 00/29] ath10k: mac80211 driver for Qualcomm Atheros qca988x devices
References: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
	<1368633142.2194.6.camel@joe-AO722>
	<20883.44965.174742.469466@gargle.gargle.HOWL>
Date: Wed, 15 May 2013 19:08:08 +0300
In-Reply-To: <20883.44965.174742.469466@gargle.gargle.HOWL> (Sujith
	Manoharan's message of "Wed, 15 May 2013 21:24:13 +0530")
Message-ID: <87wqr0ns47.fsf@kamboji.qca.qualcomm.com> (sfid-20130515_180823_079250_66CCF893)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Joe Perches wrote:
>> Perhaps it would be reasonable to create and use standardized
>> logging ath_<level> functions for all the device ath<x>k_<level>s.
>
> Indeed.
>
> You already did that in "ath: Add and use ath_printk and ath_<level>" :)

IIRC Sujith actually suggested this to me already earlier, but I didn't
buy the idea even then. ath9k and ath10k are very different, so we
cannot share all the debug levels. I just feel that it restricts and
confuses the driver debugging too much, and all just to save something
like 100 lines of code. I'm having hard time to see why bother.

-- 
Kalle Valo
