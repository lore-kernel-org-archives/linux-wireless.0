Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33037 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753800AbdARQiJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 11:38:09 -0500
Received: by mail-ot0-f194.google.com with SMTP id f9so1661682otd.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 08:38:04 -0800 (PST)
Subject: Re: [3/3] rtlwifi: Enable debug mask to be set from sysfs
To: Kalle Valo <kvalo@codeaurora.org>
References: <20170101010706.13234-4-Larry.Finger@lwfinger.net>
 <20170118144936.91B3E6080C@smtp.codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5aefd440-1b6f-1791-d85b-e71464c47620@lwfinger.net> (sfid-20170118_173819_059159_ACD66C7A)
Date: Wed, 18 Jan 2017 10:38:01 -0600
MIME-Version: 1.0
In-Reply-To: <20170118144936.91B3E6080C@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2017 08:49 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> The previous commit changes the debug system to use a mask to select
>> which components are to be debugged. Now, we add the necessary code
>> to change the mask from sysfs.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Ping-Ke Shih <pkshih@realtek.com>
>
> There's already a generic sysfs interface to change module parameters in
> /sys/module/<driver>/parameters, drivers should not have a private interface for
> that.

Kalle,

I was not aware of that part of sysfs. I will respin the patch as well as remove 
the old code that set the debug level.

Thanks,

Larry
