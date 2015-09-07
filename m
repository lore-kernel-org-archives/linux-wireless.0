Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34544 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbbIGSuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 14:50:23 -0400
Received: by oiev17 with SMTP id v17so47361288oie.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2015 11:50:23 -0700 (PDT)
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
 <1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
 <87383kps0o.fsf@kamboji.qca.qualcomm.com> <wrfjvbggfhuj.fsf@redhat.com>
 <8737yrhdm0.fsf@kamboji.qca.qualcomm.com> <wrfjlhcidq9b.fsf@redhat.com>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55EDDC6D.80000@lwfinger.net> (sfid-20150907_205026_889091_F7BD7D96)
Date: Mon, 7 Sep 2015 13:50:21 -0500
MIME-Version: 1.0
In-Reply-To: <wrfjlhcidq9b.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/07/2015 01:43 PM, Jes Sorensen wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>> Hi,
>>
>> replying to an old thread first.
>>
>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>>
>>> Kalle Valo <kvalo@codeaurora.org> writes:
>>>> Jes.Sorensen@redhat.com writes:
>>>>
>>>>>   MAINTAINERS                          |    8 +
>>>>>   drivers/net/wireless/Kconfig         |   19 +
>>>>>   drivers/net/wireless/Makefile        |    2 +
>>>>>   drivers/net/wireless/rtl8xxxu.c | 4500
>>>>> ++++++++++++++++++++++++++++++++++
>>>>>   drivers/net/wireless/rtl8xxxu.h      |  497 ++++
>>>>>   drivers/net/wireless/rtl8xxxu_regs.h |  941 +++++++
>>>>
>>>> I think someone else already mentioned, but it would be better that has
>>>> it's own directory. Or should this actually be under rtlwifi
>>>> directory?
>>>
>>> I didn't see the need here - it's just 3 files, as long as it doesn't
>>> have a huge hierachy of files, a new directory doesn't add much
>>> value. If it becomes an issue later, we can move it into a
>>> subdirectory.
>>
>> It's easier that the driver has it's on directory as everything
>> (makefile, kconfig etc) is cleanly separated. And actually I would like
>> to create a new vendor directory for realtek and have this in
>> drivers/net/wireless/realtek/rtl8xxxu/. And later we could move rtlwifi
>> under realtek directory as well.
>
> If you want to create drivers/net/wireless/realtek, that is fine with
> me, but maybe you can go ahead and create that first and move the
> existing drivers in there?

I will submit a patch to do that.

Larry


