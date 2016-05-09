Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45667 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbcEIORz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 10:17:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jaap Jan Meijer <jjmeijer88@gmail.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] Fix regression in Android due to rework .get_station() callback
References: <1462280620-13000-1-git-send-email-jjmeijer88@gmail.com>
	<87poszs8tc.fsf@kamboji.qca.qualcomm.com>
	<CAA+NYvTxA_u1kjwmY+VTnhK0G1b5cEcx2QA90fTTEkci4gWvcQ@mail.gmail.com>
	<87wpn7p6dv.fsf@kamboji.qca.qualcomm.com>
	<CAA+NYvS3ksstny_Lzw8mLu6=0uKO0VhjuwCyxS9YC-Pb+FaYJA@mail.gmail.com>
	<87futvp432.fsf@kamboji.qca.qualcomm.com>
	<CAA+NYvT5gzvdyeYx_CKaEKvpdzEJ_09U1-xSaCE7pQH+Qx9uYA@mail.gmail.com>
Date: Mon, 09 May 2016 17:17:48 +0300
In-Reply-To: <CAA+NYvT5gzvdyeYx_CKaEKvpdzEJ_09U1-xSaCE7pQH+Qx9uYA@mail.gmail.com>
	(Jaap Jan Meijer's message of "Sun, 8 May 2016 12:20:03 +0100")
Message-ID: <87futrl3hv.fsf@kamboji.qca.qualcomm.com> (sfid-20160509_161759_597588_6BE08C4B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jaap Jan Meijer <jjmeijer88@gmail.com> writes:

> 2016-05-06 17:02 GMT+01:00 Kalle Valo <kvalo@codeaurora.org>:
>> Jaap Jan Meijer <jjmeijer88@gmail.com> writes:
>>
>>> 2016-05-06 16:12 GMT+01:00 Kalle Valo <kvalo@codeaurora.org>:
>>>> Jaap Jan Meijer <jjmeijer88@gmail.com> writes:
>>>>
>>>>> I'm not sure what went wrong with the commit hash, its actually this commit:
>>>>> 1f0dc59a6de93586fcfc04696a61946408ffc56a.
>>>>
>>>> That commit id looks to be valid.
>>>>
>>>>> I see you did this commit, maybe you can check if this actually is the root
>>>>> cause? I'm sure you have a lot more insight into this issue than I do.
>>
>> I just commited the patch. Broadcom folks (CCed) should be able to
>> answer better, most likely they missed this patch as the title didn't
>> have "brcmfmac".
>
> Thanks, so no need to send a revised patch? Also, could you please
> point me to the right repository so I can follow the progress?

Sorry, I had very bad choise of words. I meant that I only commit
patches (like the commit 1f0dc59a6d we are discussing here), I'm not
familiar with brcmfmac internals. So I have NOT applied this patch and
you need to send v2. I see that Arend also found some issues, please
follow his advice.

> Also, could you please point me to the right repository so I can
> follow the progress?

You can check that from MAINTAINERS file:

NETWORKING DRIVERS (WIRELESS)
M:      Kalle Valo <kvalo@codeaurora.org>
L:      linux-wireless@vger.kernel.org
Q:      http://patchwork.kernel.org/project/linux-wireless/list/
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
S:      Maintained
F:      drivers/net/wireless/

But wireless-testing tree, maintained by Bob Copeland, is handy to
follow the status because it contains all the wireless trees:

https://git.kernel.org/cgit/linux/kernel/git/wireless/wireless-testing.git/

-- 
Kalle Valo
