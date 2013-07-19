Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:13544 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab3GSLnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 07:43:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: fixes
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
	<871u6u4xkk.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQna=a66_g+_WG8mnENEDEiUcAysa-joeP-xmTM+mYfY=Q@mail.gmail.com>
Date: Fri, 19 Jul 2013 14:43:28 +0300
In-Reply-To: <CA+BoTQna=a66_g+_WG8mnENEDEiUcAysa-joeP-xmTM+mYfY=Q@mail.gmail.com>
	(Michal Kazior's message of "Fri, 19 Jul 2013 13:10:52 +0200")
Message-ID: <87wqom3hcv.fsf@kamboji.qca.qualcomm.com> (sfid-20130719_134358_450599_B8797B8B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 19 July 2013 13:07, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> Hi,
>>>
>>> Here are some fixes for ath10k. The rts threshold
>>> patch addresses my mistake in commit
>>> 9aeb6fe53d1f0d6e58658484ce9ad7b59f0ef16b which
>>> caused rts to be always enabled causing throughput
>>> issues in some cases.
>>>
>>>
>>> Michal Kazior (3):
>>>   ath10k: prevent HTC from being used after stopping
>>>   ath10k: fix memleak in mac setup
>>>   ath10k: fix rts/fragmentation threshold setup
>>
>> Doesn't apply:
>>
>> Applying: ath10k: prevent HTC from being used after stopping
>> Applying: ath10k: fix memleak in mac setup
>> Applying: ath10k: fix rts/fragmentation threshold setup
>> fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/mac.c).
>> Repository lacks necessary blobs to fall back on 3-way merge.
>> Cannot fall back to three-way merge.
>> Patch failed at 0003 ath10k: fix rts/fragmentation threshold setup
>
> Eww. Sorry about that (I did warn you though). Perhaps that's because
> you skipped one of the recovery patches that git is confused now.

No worries. Most likely I could have fixed the conflict myself, but if
3-way merge doesn't work it's too much work.

> I'll resend the whole patchset rebased and with the HTC patch fixed.

Thanks.

-- 
Kalle Valo
