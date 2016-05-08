Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36152 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbcEHLUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2016 07:20:24 -0400
Received: by mail-wm0-f48.google.com with SMTP id n129so105274381wmn.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 May 2016 04:20:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87futvp432.fsf@kamboji.qca.qualcomm.com>
References: <1462280620-13000-1-git-send-email-jjmeijer88@gmail.com>
 <87poszs8tc.fsf@kamboji.qca.qualcomm.com> <CAA+NYvTxA_u1kjwmY+VTnhK0G1b5cEcx2QA90fTTEkci4gWvcQ@mail.gmail.com>
 <87wpn7p6dv.fsf@kamboji.qca.qualcomm.com> <CAA+NYvS3ksstny_Lzw8mLu6=0uKO0VhjuwCyxS9YC-Pb+FaYJA@mail.gmail.com>
 <87futvp432.fsf@kamboji.qca.qualcomm.com>
From: Jaap Jan Meijer <jjmeijer88@gmail.com>
Date: Sun, 8 May 2016 12:20:03 +0100
Message-ID: <CAA+NYvT5gzvdyeYx_CKaEKvpdzEJ_09U1-xSaCE7pQH+Qx9uYA@mail.gmail.com> (sfid-20160508_132152_771691_EB3999A4)
Subject: Re: [PATCH] Fix regression in Android due to rework .get_station() callback
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2016-05-06 17:02 GMT+01:00 Kalle Valo <kvalo@codeaurora.org>:
> Jaap Jan Meijer <jjmeijer88@gmail.com> writes:
>
>> 2016-05-06 16:12 GMT+01:00 Kalle Valo <kvalo@codeaurora.org>:
>>> Jaap Jan Meijer <jjmeijer88@gmail.com> writes:
>>>
>>>> Hi Kalle,
>>>>
>>>> Op vr 6 mei 2016 12:52 schreef Kalle Valo <kvalo@codeaurora.org>:
>>>>
>>>>
>>>>     This has multiple issues:
>>>>
>>>>     o Use your full name.
>>>>     o Use prefix "brcmfmac: " in the title.
>>>>
>>>>     o I can't find commit f654d13, is the commit id really correct?
>>>>     o Also check from SubmittingPatches how you should reference commit ids.
>>>>
>>>>
>>>>
>>>> Thank you for the feedback, I will send a reworked patch as soon as I get home
>>>> next week. Also I did this against v4.4.8 so I'll have to rebase it as well.
>>>>
>>>> I'm not sure what went wrong with the commit hash, its actually this commit:
>>>> 1f0dc59a6de93586fcfc04696a61946408ffc56a.
>>>
>>> That commit id looks to be valid.
>>>
>>>> I see you did this commit, maybe you can check if this actually is the root
>>>> cause? I'm sure you have a lot more insight into this issue than I do.
>
> I just commited the patch. Broadcom folks (CCed) should be able to
> answer better, most likely they missed this patch as the title didn't
> have "brcmfmac".
>
> --
> Kalle Valo

Thanks, so no need to send a revised patch? Also, could you please
point me to the right repository so I can follow the progress?
