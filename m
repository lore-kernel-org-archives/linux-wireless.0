Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752379AbeEOKCJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 06:02:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH 5/8] btmrvl: support sysfs initiated firmware coredump
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
        <1526375691-31789-6-git-send-email-arend.vanspriel@broadcom.com>
        <87bmdhp8os.fsf@kamboji.qca.qualcomm.com>
        <5AFAAF05.2020207@broadcom.com>
Date: Tue, 15 May 2018 13:02:04 +0300
In-Reply-To: <5AFAAF05.2020207@broadcom.com> (Arend van Spriel's message of
        "Tue, 15 May 2018 11:57:25 +0200")
Message-ID: <8736ytp78j.fsf@kamboji.qca.qualcomm.com> (sfid-20180515_120218_171772_A7896F5A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> + Marcel, bt-list
>
> On 5/15/2018 11:30 AM, Kalle Valo wrote:
>> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>>
>>> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
>>> it is possible to initiate a device coredump from user-space. This
>>> patch adds support for it in btmrvl_sdio adding the .coredump()
>>> driver callback. This makes dump through debugfs obsolete so removing
>>> it.
>>>
>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>> ---
>>>   drivers/bluetooth/btmrvl_debugfs.c | 31 -------------------------------
>>>   drivers/bluetooth/btmrvl_drv.h     |  2 --
>>>   drivers/bluetooth/btmrvl_main.c    |  6 ------
>>>   drivers/bluetooth/btmrvl_sdio.c    | 11 ++++++++---
>>>   4 files changed, 8 insertions(+), 42 deletions(-)
>>
>> Shouldn't this go via bluetooth tree?
>
> Ah, yes. I should at least have added bt-list to Cc: I can submit this
> separately so you can drop it or can you coordinate with Marcel how to
> deal with it. Maybe it is fine to take this to w-d tree?

I prefer submitting this patch separately to the bluetooth tree (and
I'll drop this version from my queue).

-- 
Kalle Valo
