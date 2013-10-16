Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:32921 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934637Ab3JPOF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 10:05:58 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so294330bkb.10
        for <linux-wireless@vger.kernel.org>; Wed, 16 Oct 2013 07:05:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bo2p74sp.fsf@kamboji.qca.qualcomm.com>
References: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
	<8761sybbye.fsf@kamboji.qca.qualcomm.com>
	<87bo2p74sp.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 16 Oct 2013 07:05:56 -0700
Message-ID: <CA+BoTQ=wpEWF3sWavKSfKy4s6qW097amCt_VqbapZg-ECWOE=g@mail.gmail.com> (sfid-20131016_160619_500761_1B42ABF7)
Subject: Re: [PATCH 0/7] ath10k: fixes 2013-10-15
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 October 2013 05:56, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> This is a bunch of fixes I've had queued up for
>>> some time now. I was reluctant to send them
>>> without some additional checks and because some of
>>> the fixes are not ideal. At least we can get a
>>> discussion going if anything raises any serious
>>> concern.
>>>
>>>
>>> Michal Kazior (7):
>>>   ath10k: prevent starting monitor without a vdev
>>>   ath10k: add sanity checks for monitor management
>>>   ath10k: fix endianess in prints
>>>   ath10k: fix NSS reporting in RX
>>>   ath10k: fix NULL deref upon early FW crash
>>>   ath10k: fix device initialization routine
>>>   ath10k: fix FW crashes on heavy TX on 10.1.389 AP FW
>>
>> I get few long line warnings:
>>
>> drivers/net/wireless/ath/ath10k/pci.c:1842: WARNING: line over 80 characters
>> drivers/net/wireless/ath/ath10k/pci.c:1844: WARNING: line over 80 characters
>> drivers/net/wireless/ath/ath10k/pci.c:1847: WARNING: line over 80 characters
>> drivers/net/wireless/ath/ath10k/pci.c:1848: WARNING: line over 80 characters
>> drivers/net/wireless/ath/ath10k/pci.c:1856: WARNING: line over 80 characters
>> drivers/net/wireless/ath/ath10k/pci.c:1875: WARNING: line over 80 characters
>> drivers/net/wireless/ath/ath10k/pci.c:1877: WARNING: line over 80 characters
>> drivers/net/wireless/ath/ath10k/pci.c:1883: WARNING: line over 80 characters
>> drivers/net/wireless/ath/ath10k/mac.c:2284: WARNING: line over 80 characters
>
> Michal, if it's ok for you I'll submit v2 of this patchset. I'll fix the
> long line warnings and also I do small cleanup to the warm reset code.

I am totally okay with this. Thank you for your trouble.


Micał
