Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18068 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbbIBNzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 09:55:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: change beamformee VHT STS capability
References: <1440679653-20289-1-git-send-email-michal.kazior@tieto.com>
	<CACKGw+FU0tQ4HZ0O=AB8uo-HyNshr0zjd-Hb+4NytpzsOH4TdQ@mail.gmail.com>
	<CACKGw+GQKt3frfGxU=M8XLg6adM5GVBasPd5OrwrGMaCvNsvzA@mail.gmail.com>
Date: Wed, 2 Sep 2015 16:55:23 +0300
In-Reply-To: <CACKGw+GQKt3frfGxU=M8XLg6adM5GVBasPd5OrwrGMaCvNsvzA@mail.gmail.com>
	(Bartosz Markowski's message of "Wed, 2 Sep 2015 13:25:04 +0200")
Message-ID: <87d1y1lyd0.fsf@kamboji.qca.qualcomm.com> (sfid-20150902_155551_432676_5D481224)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> On 28 August 2015 at 14:56, Bartosz Markowski
> <bartosz.markowski@tieto.com> wrote:
>> On 27 August 2015 at 14:47, Michal Kazior <michal.kazior@tieto.com> wrote:
>>> From: Bartosz Markowski <bartosz.markowski@tieto.com>
>>>
>>> All beamformee supporting chips have the ability to support
>>> VHT NDP in up to 4 STSs. Change the published beamformee
>>> STS cap accordingly to 3 as it should be Nsts-1.
>>>
>>> This makes it possible to actually make full use
>>> of. e.g. a 4SS MU-MIMO capable AP.
>>>
>>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>> ---
>>
>> Kalle, please drop this one for now. It looks like we need to discuss
>> about this a bit more still.
>
> I have sent a follow up on this, splitting it into 2 patches (vht nsts
> and sounding dimensions), addressing the concerns raised about the
> lack of firmware passing the needed bits in vht_cap_info.

Ok, patch 1 dropped. I assume patch 2 is still valid.

-- 
Kalle Valo
