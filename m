Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:44203 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755199AbeAHSa5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 13:30:57 -0500
Received: by mail-yb0-f182.google.com with SMTP id h189so4894219ybc.11
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jan 2018 10:30:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87o9m42p2k.fsf@kamboji.qca.qualcomm.com>
References: <18a56326d68a7d53f3197e450cae0e28382d8d2c.1513252573.git.lorenzo.bianconi@redhat.com>
 <20180108173523.B23C360B22@smtp.codeaurora.org> <CAJ0CqmWEgC07iBkkt92fKTpagMx+_oim_3qcPoc=B6ttsUzoOA@mail.gmail.com>
 <87o9m42p2k.fsf@kamboji.qca.qualcomm.com>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Mon, 8 Jan 2018 19:30:56 +0100
Message-ID: <CAJ0CqmV9C70SbxGk4aNDeKovHFCCH65Z7zfA2+WWDKqzkwmEvw@mail.gmail.com> (sfid-20180108_193101_207114_36FD1336)
Subject: Re: [1/2] mt76: fix possible NULL pointer dereferencing in mt76x2_ampdu_action()
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Felix Fietkau <nbd@nbd.name>, dan.carpenter@oracle.com,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
>
> --
> Kalle Valo

They should be fine since he merged them in mt76 github repo:
- https://github.com/openwrt/mt76/commit/ca5ca8c779932e7cab3224053377b29f139904b9
- https://github.com/openwrt/mt76/commit/2d4b8f57cc5e3101d45785ae9a9f1eb6fc229de9

Anyway we can wait for him, up to you.
Regards,

Lorenzo
