Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36263 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140AbcEFQCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 12:02:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jaap Jan Meijer <jjmeijer88@gmail.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] Fix regression in Android due to rework .get_station() callback
References: <1462280620-13000-1-git-send-email-jjmeijer88@gmail.com>
	<87poszs8tc.fsf@kamboji.qca.qualcomm.com>
	<CAA+NYvTxA_u1kjwmY+VTnhK0G1b5cEcx2QA90fTTEkci4gWvcQ@mail.gmail.com>
	<87wpn7p6dv.fsf@kamboji.qca.qualcomm.com>
	<CAA+NYvS3ksstny_Lzw8mLu6=0uKO0VhjuwCyxS9YC-Pb+FaYJA@mail.gmail.com>
Date: Fri, 06 May 2016 19:02:25 +0300
In-Reply-To: <CAA+NYvS3ksstny_Lzw8mLu6=0uKO0VhjuwCyxS9YC-Pb+FaYJA@mail.gmail.com>
	(Jaap Jan Meijer's message of "Fri, 6 May 2016 16:57:11 +0100")
Message-ID: <87futvp432.fsf@kamboji.qca.qualcomm.com> (sfid-20160506_180234_981692_9E0779D0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jaap Jan Meijer <jjmeijer88@gmail.com> writes:

> 2016-05-06 16:12 GMT+01:00 Kalle Valo <kvalo@codeaurora.org>:
>> Jaap Jan Meijer <jjmeijer88@gmail.com> writes:
>>
>>> Hi Kalle,
>>>
>>> Op vr 6 mei 2016 12:52 schreef Kalle Valo <kvalo@codeaurora.org>:
>>>
>>>
>>>     This has multiple issues:
>>>
>>>     o Use your full name.
>>>     o Use prefix "brcmfmac: " in the title.
>>>
>>>     o I can't find commit f654d13, is the commit id really correct?
>>>     o Also check from SubmittingPatches how you should reference commit ids.
>>>
>>>
>>>
>>> Thank you for the feedback, I will send a reworked patch as soon as I get home
>>> next week. Also I did this against v4.4.8 so I'll have to rebase it as well.
>>>
>>> I'm not sure what went wrong with the commit hash, its actually this commit:
>>> 1f0dc59a6de93586fcfc04696a61946408ffc56a.
>>
>> That commit id looks to be valid.
>>
>>> I see you did this commit, maybe you can check if this actually is the root
>>> cause? I'm sure you have a lot more insight into this issue than I do.

I just commited the patch. Broadcom folks (CCed) should be able to
answer better, most likely they missed this patch as the title didn't
have "brcmfmac".

-- 
Kalle Valo
