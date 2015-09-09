Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbbIIOQN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 10:16:13 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
	<1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
	<87383kps0o.fsf@kamboji.qca.qualcomm.com>
	<wrfjvbggfhuj.fsf@redhat.com>
	<8737yrhdm0.fsf@kamboji.qca.qualcomm.com>
	<wrfjlhcidq9b.fsf@redhat.com> <55EDDC6D.80000@lwfinger.net>
Date: Wed, 09 Sep 2015 10:16:09 -0400
In-Reply-To: <55EDDC6D.80000@lwfinger.net> (Larry Finger's message of "Mon, 7
	Sep 2015 13:50:21 -0500")
Message-ID: <wrfjoahb65li.fsf@redhat.com> (sfid-20150909_161633_832999_5CE3E599)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 09/07/2015 01:43 PM, Jes Sorensen wrote:
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>> Hi,
>>>
>>> replying to an old thread first.
>>>
>>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>>>
>>>> Kalle Valo <kvalo@codeaurora.org> writes:
>>>>> Jes.Sorensen@redhat.com writes:
>>>>>
>>>>>>   MAINTAINERS                          |    8 +
>>>>>>   drivers/net/wireless/Kconfig         |   19 +
>>>>>>   drivers/net/wireless/Makefile        |    2 +
>>>>>>   drivers/net/wireless/rtl8xxxu.c | 4500
>>>>>> ++++++++++++++++++++++++++++++++++
>>>>>>   drivers/net/wireless/rtl8xxxu.h      |  497 ++++
>>>>>>   drivers/net/wireless/rtl8xxxu_regs.h |  941 +++++++
>>>>>
>>>>> I think someone else already mentioned, but it would be better that has
>>>>> it's own directory. Or should this actually be under rtlwifi
>>>>> directory?
>>>>
>>>> I didn't see the need here - it's just 3 files, as long as it doesn't
>>>> have a huge hierachy of files, a new directory doesn't add much
>>>> value. If it becomes an issue later, we can move it into a
>>>> subdirectory.
>>>
>>> It's easier that the driver has it's on directory as everything
>>> (makefile, kconfig etc) is cleanly separated. And actually I would like
>>> to create a new vendor directory for realtek and have this in
>>> drivers/net/wireless/realtek/rtl8xxxu/. And later we could move rtlwifi
>>> under realtek directory as well.
>>
>> If you want to create drivers/net/wireless/realtek, that is fine with
>> me, but maybe you can go ahead and create that first and move the
>> existing drivers in there?
>
> I will submit a patch to do that.

Awesome, once I see that go in, I'll move rtl8xxxu into that directory.

Cheers,
Jes
