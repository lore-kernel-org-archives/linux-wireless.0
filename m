Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48880 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754933AbeAHSQ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 13:16:59 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Felix Fietkau <nbd@nbd.name>, dan.carpenter@oracle.com,
        linux-wireless@vger.kernel.org
Subject: Re: [1/2] mt76: fix possible NULL pointer dereferencing in mt76x2_ampdu_action()
References: <18a56326d68a7d53f3197e450cae0e28382d8d2c.1513252573.git.lorenzo.bianconi@redhat.com>
        <20180108173523.B23C360B22@smtp.codeaurora.org>
        <CAJ0CqmWEgC07iBkkt92fKTpagMx+_oim_3qcPoc=B6ttsUzoOA@mail.gmail.com>
Date: Mon, 08 Jan 2018 20:16:51 +0200
In-Reply-To: <CAJ0CqmWEgC07iBkkt92fKTpagMx+_oim_3qcPoc=B6ttsUzoOA@mail.gmail.com>
        (Lorenzo Bianconi's message of "Mon, 8 Jan 2018 18:44:07 +0100")
Message-ID: <87o9m42p2k.fsf@kamboji.qca.qualcomm.com> (sfid-20180108_191703_003584_24BDCDB0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>>
>>> Initialize mt76_txq pointer after ieee80211_txq pointer check.
>>> Remove space after the pointer cast
>>>
>>> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
>>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>>
>> What am I supposed to do with this and patch 2? Drop?
>
> What do you mean? Why drop?

I didn't see Felix's ack, at least not on patchwork.

-- 
Kalle Valo
