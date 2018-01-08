Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:42470 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752659AbeAHRoI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:44:08 -0500
Received: by mail-yw0-f194.google.com with SMTP id z132so4595339ywd.9
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jan 2018 09:44:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180108173523.B23C360B22@smtp.codeaurora.org>
References: <18a56326d68a7d53f3197e450cae0e28382d8d2c.1513252573.git.lorenzo.bianconi@redhat.com>
 <20180108173523.B23C360B22@smtp.codeaurora.org>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Mon, 8 Jan 2018 18:44:07 +0100
Message-ID: <CAJ0CqmWEgC07iBkkt92fKTpagMx+_oim_3qcPoc=B6ttsUzoOA@mail.gmail.com> (sfid-20180108_184412_289545_38650D12)
Subject: Re: [1/2] mt76: fix possible NULL pointer dereferencing in mt76x2_ampdu_action()
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Felix Fietkau <nbd@nbd.name>, dan.carpenter@oracle.com,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>
>> Initialize mt76_txq pointer after ieee80211_txq pointer check.
>> Remove space after the pointer cast
>>
>> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>
> What am I supposed to do with this and patch 2? Drop?

Hi Kalle,

What do you mean? Why drop?

Regards,
Lorenzo

>
> --
> https://patchwork.kernel.org/patch/10111937/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>
