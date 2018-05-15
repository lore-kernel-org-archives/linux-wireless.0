Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32792 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752427AbeEOKhw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 06:37:52 -0400
Received: by mail-wm0-f66.google.com with SMTP id x12-v6so15326076wmc.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 03:37:51 -0700 (PDT)
Subject: Re: [PATCH 5/8] btmrvl: support sysfs initiated firmware coredump
To: Kalle Valo <kvalo@codeaurora.org>
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
 <1526375691-31789-6-git-send-email-arend.vanspriel@broadcom.com>
 <87bmdhp8os.fsf@kamboji.qca.qualcomm.com> <5AFAAF05.2020207@broadcom.com>
 <8736ytp78j.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AFAB87E.7050205@broadcom.com> (sfid-20180515_123757_371054_C3CC9AEF)
Date: Tue, 15 May 2018 12:37:50 +0200
MIME-Version: 1.0
In-Reply-To: <8736ytp78j.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/15/2018 12:02 PM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> + Marcel, bt-list
>>
>> On 5/15/2018 11:30 AM, Kalle Valo wrote:
>>> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>>>
>>>> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
>>>> it is possible to initiate a device coredump from user-space. This
>>>> patch adds support for it in btmrvl_sdio adding the .coredump()
>>>> driver callback. This makes dump through debugfs obsolete so removing
>>>> it.
>>>>
>>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>> ---
>>>>    drivers/bluetooth/btmrvl_debugfs.c | 31 -------------------------------
>>>>    drivers/bluetooth/btmrvl_drv.h     |  2 --
>>>>    drivers/bluetooth/btmrvl_main.c    |  6 ------
>>>>    drivers/bluetooth/btmrvl_sdio.c    | 11 ++++++++---
>>>>    4 files changed, 8 insertions(+), 42 deletions(-)
>>>
>>> Shouldn't this go via bluetooth tree?
>>
>> Ah, yes. I should at least have added bt-list to Cc: I can submit this
>> separately so you can drop it or can you coordinate with Marcel how to
>> deal with it. Maybe it is fine to take this to w-d tree?
>
> I prefer submitting this patch separately to the bluetooth tree (and
> I'll drop this version from my queue).

Fine by me.

Regards,
Arend
