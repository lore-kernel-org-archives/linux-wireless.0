Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35729 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbeEOJ52 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:57:28 -0400
Received: by mail-qk0-f196.google.com with SMTP id c137-v6so12419398qkg.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 02:57:28 -0700 (PDT)
Subject: Re: [PATCH 5/8] btmrvl: support sysfs initiated firmware coredump
To: Kalle Valo <kvalo@codeaurora.org>
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
 <1526375691-31789-6-git-send-email-arend.vanspriel@broadcom.com>
 <87bmdhp8os.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AFAAF05.2020207@broadcom.com> (sfid-20180515_115803_927281_41EFC368)
Date: Tue, 15 May 2018 11:57:25 +0200
MIME-Version: 1.0
In-Reply-To: <87bmdhp8os.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Marcel, bt-list

On 5/15/2018 11:30 AM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
>> it is possible to initiate a device coredump from user-space. This
>> patch adds support for it in btmrvl_sdio adding the .coredump()
>> driver callback. This makes dump through debugfs obsolete so removing
>> it.
>>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
>>   drivers/bluetooth/btmrvl_debugfs.c | 31 -------------------------------
>>   drivers/bluetooth/btmrvl_drv.h     |  2 --
>>   drivers/bluetooth/btmrvl_main.c    |  6 ------
>>   drivers/bluetooth/btmrvl_sdio.c    | 11 ++++++++---
>>   4 files changed, 8 insertions(+), 42 deletions(-)
>
> Shouldn't this go via bluetooth tree?

Ah, yes. I should at least have added bt-list to Cc: I can submit this 
separately so you can drop it or can you coordinate with Marcel how to 
deal with it. Maybe it is fine to take this to w-d tree?

Regards,
Arend
