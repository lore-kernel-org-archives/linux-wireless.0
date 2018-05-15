Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33478 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752582AbeEOJ6O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:58:14 -0400
Received: by mail-qt0-f196.google.com with SMTP id e8-v6so19979138qth.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 02:58:14 -0700 (PDT)
Subject: Re: [PATCH 0/8] brcmfmac: coredump functionality and fixes
To: Kalle Valo <kvalo@codeaurora.org>
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
 <877eo5p8ml.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AFAAF34.4030906@broadcom.com> (sfid-20180515_115825_985131_CCFFD85F)
Date: Tue, 15 May 2018 11:58:12 +0200
MIME-Version: 1.0
In-Reply-To: <877eo5p8ml.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/15/2018 11:32 AM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> This series is intended for 4.18:
>>
>>   * fix variable initialization found by kbuild bot.
>>   * make ALLFFMAC variable static.
>>   * support user-space initiated coredump.
>>
>> The first two patches in this series apply to the master branch of the
>> wireless-drivers-next repository. The remaining patches related to coredump
>> functionality are dependent upon a commit present since v4.17-rc3:
>>
>>    commit ed4564babeeee4fb19fe4ec0beabe29754e380f9
>>    Author: Arend van Spriel <aspriel@gmail.com>
>>    Date:   Sun Apr 8 23:57:07 2018 +0200
>>
>>       drivers: change struct device_driver::coredump() return type to void
>>
>> Both w-d-next and bt-next (for patch 5/8) do not carry this patch yet.
>
> So what I'm planning to do is apply patch 1 now to fix the warning, send
> a pull request to Dave and then fast forward w-d-next so that I can
> apply rest of the patches.

Ok. Sounds good.

Regards,
Arend
