Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:30907 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaENOZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 10:25:18 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 0/2] ath10k: warm reset fixes 2014-05-14
References: <1400050658-2763-1-git-send-email-michal.kazior@tieto.com>
	<87bnv0fnjm.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 14 May 2014 17:25:10 +0300
In-Reply-To: <87bnv0fnjm.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Wed, 14 May 2014 17:22:05 +0300")
Message-ID: <877g5ofneh.fsf@kamboji.qca.qualcomm.com> (sfid-20140514_162523_660075_129FF129)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Warm reset was not able to recover from a device
>> crash so ath10k was falling back to cold reset
>> which would occasionally hang the system or
>> generate a data bus error with some device chips.
>>
>> Warm reset now works a lot more reliably (at least
>> on my T430). It's able to recover from a "hard"
>> simulate fw crash and some firmware asserts I've
>> forced meaning it should recover in most cases
>> without falling back to the cold reset.
>>
>> There's still one case of a crash warm reset is
>> incapable to recover from: IOMMU faults (when
>> supported and enabled and device tries to access
>> non-DMA mapped host memory) trigger device crash
>> and leave CE totally unresponsive before and after
>> the warm reset.
>>
>>
>> Michal Kazior (2):
>>   ath10k: improve warm reset reliability
>>   ath10k: retry warm reset a few times
>
> The patches don't apply anymore and the conflict was not trivial enough
> for me to fix it. Can you rebase, please?

Sorry, I replied to the wrong thread. Please ignore what I said above!

-- 
Kalle Valo
