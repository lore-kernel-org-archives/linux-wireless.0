Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18822 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934440Ab3JPOSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 10:18:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH 0/7] ath10k: fixes 2013-10-15
References: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
	<8761sybbye.fsf@kamboji.qca.qualcomm.com>
	<87bo2p74sp.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=wpEWF3sWavKSfKy4s6qW097amCt_VqbapZg-ECWOE=g@mail.gmail.com>
Date: Wed, 16 Oct 2013 17:18:15 +0300
In-Reply-To: <CA+BoTQ=wpEWF3sWavKSfKy4s6qW097amCt_VqbapZg-ECWOE=g@mail.gmail.com>
	(Michal Kazior's message of "Wed, 16 Oct 2013 07:05:56 -0700")
Message-ID: <8738o17108.fsf@kamboji.qca.qualcomm.com> (sfid-20131016_161840_878872_5A7F067B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 16 October 2013 05:56, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>>
>> Michal, if it's ok for you I'll submit v2 of this patchset. I'll fix the
>> long line warnings and also I do small cleanup to the warm reset code.
>
> I am totally okay with this. Thank you for your trouble.

As you can see, I changed the warm reset code quite a lot. If you have
time, please review that carefully.

-- 
Kalle Valo
