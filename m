Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:41435 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbbDARJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 13:09:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: implement more versatile set_bitrate_mask
References: <1427798961-7334-1-git-send-email-michal.kazior@tieto.com>
	<1427798961-7334-3-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQmhEf3fZSo2FPFbXa=Uc4ia0Sg2SD89gceyc8O+jVJeUg@mail.gmail.com>
Date: Wed, 1 Apr 2015 20:09:23 +0300
In-Reply-To: <CA+BoTQmhEf3fZSo2FPFbXa=Uc4ia0Sg2SD89gceyc8O+jVJeUg@mail.gmail.com>
	(Michal Kazior's message of "Wed, 1 Apr 2015 14:38:13 +0200")
Message-ID: <87iodfzsfw.fsf@kamboji.qca.qualcomm.com> (sfid-20150401_190937_950440_5277FDB8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 31 March 2015 at 12:49, Michal Kazior <michal.kazior@tieto.com> wrote:
>> Until now only a single fixed tx rate or nss was
>> allowed to be set.
>>
>> The patch attempts to improve this by allowing
>> most bitrate masks. The limitation is VHT MCS
>> rates cannot be expressed separately and only the
>> following VHT MCS ranges are supported: none, 0-7,
>> 0-8, and 0-9.
>>
>> This keeps the old behaviour when requesting
>> single tx rate or single nss. The new bitrate mask
>> logic is only applied to other cases that would
>> return -EINVAL until now.
>>
>> Depending on firmware revisions some combinations
>> may crash firmware so use with care, please.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>
> Hi Kalle,
>
> Drop this patch ([2/2]) for now, please. It looks like it doesn't work
> well with crypto networks. I'll need to rework this. The [1/2] is fine
> as it is though.

Ok, patch 2 dropped.

-- 
Kalle Valo
