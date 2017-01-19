Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59240 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdASJHN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 04:07:13 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [3/3] rtlwifi: Enable debug mask to be set from sysfs
References: <20170101010706.13234-4-Larry.Finger@lwfinger.net>
        <20170118144936.91B3E6080C@smtp.codeaurora.org>
        <5aefd440-1b6f-1791-d85b-e71464c47620@lwfinger.net>
Date: Thu, 19 Jan 2017 10:57:23 +0200
In-Reply-To: <5aefd440-1b6f-1791-d85b-e71464c47620@lwfinger.net> (Larry
        Finger's message of "Wed, 18 Jan 2017 10:38:01 -0600")
Message-ID: <87h94vpguk.fsf@kamboji.qca.qualcomm.com> (sfid-20170119_100738_045232_430391BD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 01/18/2017 08:49 AM, Kalle Valo wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> The previous commit changes the debug system to use a mask to select
>>> which components are to be debugged. Now, we add the necessary code
>>> to change the mask from sysfs.
>>>
>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>>> Cc: Ping-Ke Shih <pkshih@realtek.com>
>>
>> There's already a generic sysfs interface to change module parameters in
>> /sys/module/<driver>/parameters, drivers should not have a private interface for
>> that.
>
> Kalle,
>
> I was not aware of that part of sysfs. I will respin the patch as well
> as remove the old code that set the debug level.

Good, thanks. I dropped the whole series now and assume that you will
send v2.

-- 
Kalle Valo
