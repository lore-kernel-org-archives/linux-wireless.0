Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36032 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750810AbeAQK0P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 05:26:15 -0500
Subject: Re: [1/2] mt76: fix possible NULL pointer dereferencing in
 mt76x2_ampdu_action()
To: Kalle Valo <kvalo@codeaurora.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: dan.carpenter@oracle.com, linux-wireless@vger.kernel.org
References: <18a56326d68a7d53f3197e450cae0e28382d8d2c.1513252573.git.lorenzo.bianconi@redhat.com>
 <20180108173523.B23C360B22@smtp.codeaurora.org>
 <CAJ0CqmWEgC07iBkkt92fKTpagMx+_oim_3qcPoc=B6ttsUzoOA@mail.gmail.com>
 <87o9m42p2k.fsf@kamboji.qca.qualcomm.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <5835442f-9e10-69bb-3b6d-d207d540181f@nbd.name> (sfid-20180117_112619_445991_97476F0A)
Date: Wed, 17 Jan 2018 11:26:13 +0100
MIME-Version: 1.0
In-Reply-To: <87o9m42p2k.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-01-08 19:16, Kalle Valo wrote:
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> 
>>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>>>
>>>> Initialize mt76_txq pointer after ieee80211_txq pointer check.
>>>> Remove space after the pointer cast
>>>>
>>>> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
>>>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>>>
>>> What am I supposed to do with this and patch 2? Drop?
>>
>> What do you mean? Why drop?
> 
> I didn't see Felix's ack, at least not on patchwork.
I sent my ack (for both patches) as a reply to 0/2
These patches should go in.

- Felix
