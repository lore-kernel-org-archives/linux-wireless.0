Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60308 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaI2Hji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 03:39:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath10k: fix fw stats processing
References: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
	<1411641230-18785-5-git-send-email-michal.kazior@tieto.com>
	<8761g94hm4.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmC7vec3OW8ZbCvkx761cMtUTT6f+UAVp7dMXj2hNRKUA@mail.gmail.com>
Date: Mon, 29 Sep 2014 10:38:59 +0300
In-Reply-To: <CA+BoTQmC7vec3OW8ZbCvkx761cMtUTT6f+UAVp7dMXj2hNRKUA@mail.gmail.com>
	(Michal Kazior's message of "Mon, 29 Sep 2014 09:16:14 +0200")
Message-ID: <87iok63mgc.fsf@kamboji.qca.qualcomm.com> (sfid-20140929_093942_409883_78A1CA32)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 27 September 2014 10:01, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> If stat data exceeds wmi-htc buffer limits
>>> firmware splits it into many wmi stats update
>>> events which are delivered in a ping-pong fashion
>>> triggered by wmi stats request command.
>>>
>>> Since there's only an implicit start-of-data and
>>> no end-of-data indications the driver has to
>>> perform some trickery to get complete stat data.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> I folded the patch below in ath-next-next. Please check:
>>
>> https://github.com/kvalo/ath/commit/7071112c5ddaff761cd7d9bb3110c3f3d2f83bb8
> [...]
>
> I think you meant:
>
>   https://github.com/kvalo/ath/commit/5122a60f4fbf5a38e70a14578858b39058ee367a

Indeed. Sorry for the mixup.

> It looks good. Thanks!

Thanks for checking.

-- 
Kalle Valo
