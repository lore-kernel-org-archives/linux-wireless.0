Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31345 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaBMPrC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 10:47:02 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: AP: handle HT station which does not have HT RX MCS
References: <1392034375-13532-1-git-send-email-bartosz.markowski@tieto.com>
	<8761omdqe5.fsf@kamboji.qca.qualcomm.com>
	<CACKGw+Es7YsNHtg+MJE_82Ffm5m9hHu+qo6nZbo-hoOfqCDmOQ@mail.gmail.com>
Date: Thu, 13 Feb 2014 17:46:53 +0200
In-Reply-To: <CACKGw+Es7YsNHtg+MJE_82Ffm5m9hHu+qo6nZbo-hoOfqCDmOQ@mail.gmail.com>
	(Bartosz Markowski's message of "Tue, 11 Feb 2014 09:10:56 +0100")
Message-ID: <874n438176.fsf@kamboji.qca.qualcomm.com> (sfid-20140213_164716_020419_04B9CE08)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> On 11 February 2014 09:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>>
>>> This is a workaround for HT-enabled STAs which break the spec
>>> and have no HT capabilities RX mask (no HT RX MCS map).
>>>
>>> As per spec, in section 20.3.5 Modulation and coding scheme (MCS),
>>> MCS 0 through 7 are mandatory in 20MHz with 800 ns GI at all STAs.
>>>
>>> Firmware asserts if such situation occurs.
>>>
>>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>>
>> This conflicted with Marek K's patch "ath10k: Set proper nss value for
>> the peer". Please check that my resolution in ath-next-test is correct:
>>
>> https://github.com/kvalo/ath/commit/d56aa0e779c17f8048a70a9dbd5228b54d9a712e
>
> Looks good.

Thanks, applied.

-- 
Kalle Valo
