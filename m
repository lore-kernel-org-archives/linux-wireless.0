Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:34195 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbbIBOpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 10:45:36 -0400
Received: by ykdg206 with SMTP id g206so11836127ykd.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2015 07:45:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87d1y1lyd0.fsf@kamboji.qca.qualcomm.com>
References: <1440679653-20289-1-git-send-email-michal.kazior@tieto.com>
	<CACKGw+FU0tQ4HZ0O=AB8uo-HyNshr0zjd-Hb+4NytpzsOH4TdQ@mail.gmail.com>
	<CACKGw+GQKt3frfGxU=M8XLg6adM5GVBasPd5OrwrGMaCvNsvzA@mail.gmail.com>
	<87d1y1lyd0.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 2 Sep 2015 16:45:36 +0200
Message-ID: <CACKGw+E8N_C-zCZFhuxCSDVBy8R7sH7mk0_phnB=uKzceNUXRA@mail.gmail.com> (sfid-20150902_164539_995890_C4BD58FC)
Subject: Re: [PATCH 1/2] ath10k: change beamformee VHT STS capability
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 September 2015 at 15:55, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>
>> On 28 August 2015 at 14:56, Bartosz Markowski
>> <bartosz.markowski@tieto.com> wrote:
>>> On 27 August 2015 at 14:47, Michal Kazior <michal.kazior@tieto.com> wrote:
>>>> From: Bartosz Markowski <bartosz.markowski@tieto.com>
>>>>
>>>> All beamformee supporting chips have the ability to support
>>>> VHT NDP in up to 4 STSs. Change the published beamformee
>>>> STS cap accordingly to 3 as it should be Nsts-1.
>>>>
>>>> This makes it possible to actually make full use
>>>> of. e.g. a 4SS MU-MIMO capable AP.
>>>>
>>>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>>> ---
>>>
>>> Kalle, please drop this one for now. It looks like we need to discuss
>>> about this a bit more still.
>>
>> I have sent a follow up on this, splitting it into 2 patches (vht nsts
>> and sounding dimensions), addressing the concerns raised about the
>> lack of firmware passing the needed bits in vht_cap_info.
>
> Ok, patch 1 dropped. I assume patch 2 is still valid.

correct.

-- 
Bartosz
