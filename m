Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47746 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753051AbeAQOu3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 09:50:29 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        dan.carpenter@oracle.com, linux-wireless@vger.kernel.org
Subject: Re: [1/2] mt76: fix possible NULL pointer dereferencing in mt76x2_ampdu_action()
References: <18a56326d68a7d53f3197e450cae0e28382d8d2c.1513252573.git.lorenzo.bianconi@redhat.com>
        <20180108173523.B23C360B22@smtp.codeaurora.org>
        <CAJ0CqmWEgC07iBkkt92fKTpagMx+_oim_3qcPoc=B6ttsUzoOA@mail.gmail.com>
        <87o9m42p2k.fsf@kamboji.qca.qualcomm.com>
        <5835442f-9e10-69bb-3b6d-d207d540181f@nbd.name>
Date: Wed, 17 Jan 2018 16:50:23 +0200
In-Reply-To: <5835442f-9e10-69bb-3b6d-d207d540181f@nbd.name> (Felix Fietkau's
        message of "Wed, 17 Jan 2018 11:26:13 +0100")
Message-ID: <87o9lsczf4.fsf@kamboji.qca.qualcomm.com> (sfid-20180117_155033_045435_CA7BCC90)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2018-01-08 19:16, Kalle Valo wrote:
>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> 
>>>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>>>>
>>>>> Initialize mt76_txq pointer after ieee80211_txq pointer check.
>>>>> Remove space after the pointer cast
>>>>>
>>>>> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
>>>>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>>>>
>>>> What am I supposed to do with this and patch 2? Drop?
>>>
>>> What do you mean? Why drop?
>> 
>> I didn't see Felix's ack, at least not on patchwork.
>
> I sent my ack (for both patches) as a reply to 0/2

Ah. patchwork is annoying as it doesn't show the cover letter at all so
I missed that.

> These patches should go in.

These two are applied now.

-- 
Kalle Valo
