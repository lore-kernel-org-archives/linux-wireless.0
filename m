Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdGYLvK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 07:51:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@linux.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Birming Chiu <birming@realtek.com>, Pkshih <pkshih@realtek.com>
Subject: Re: New Realtek driver
References: <50a63e7a-045a-3386-661a-5bfe077e5b0a@lwfinger.net>
        <617F6F88-FA7B-4BB1-8DFE-AA17D0C540DF@holtmann.org>
        <daf881fc-918e-7716-2b09-20abe74f6cb3@lwfinger.net>
Date: Tue, 25 Jul 2017 14:51:04 +0300
In-Reply-To: <daf881fc-918e-7716-2b09-20abe74f6cb3@lwfinger.net> (Larry
        Finger's message of "Fri, 21 Jul 2017 21:04:37 -0500")
Message-ID: <87o9s8ka53.fsf@codeaurora.org> (sfid-20170725_135117_786725_FED0B11A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 07/21/2017 05:13 AM, Marcel Holtmann wrote:
>> Hi Larry,
>>
>>> Once again I find myself in the awkward position of needing to
>>> submit code to two different trees, i.e. wireless and staging.
>>>
>>> The code in question concerns a new Realtek device, the RTL8822BE.
>>> The device is already shipping, and Realtek would like it to be
>>> available in kernel 3.14. As it consists of ~120,000 new lines of
>>> code, I have assured Realtek that 3.14 would not be possible, at
>>> least in the wireless tree. What I plan to do is submit the changes
>>> in the existing drivers through wireless, and the three totally new
>>> drivers through staging. My expectation is that this code would
>>> live for a relatively short time there, but going that route would
>>> give time for the code to be reviewed properly, but still be
>>> available in a kernel driver. All of the new code will be available
>>> in a GitHub repo maintained by Realtek for those users whose
>>> distros do not configure anything in staging.
>>>
>>> For my part, I will push the wireless tree material as fast as I
>>> can and hope there is time available near the end of the 4.13-rcX
>>> sequence for the material to reach 4.14-rc1.
>>
>> I really do not understand the need for staging if there is already
>> active cleanup and submission to wireless-drivers happening. I find
>> it also unfair to others who submit code to linux-wireless and have
>> it reviewed there before it gets merged.
>>
>> Also the faster it gets into wireless-drivers the faster it can be
>> available via linux-backports. Seems many companies have used
>> linux-backports successfully to deal with older kernel versions.
>
> The part that is being submitted to wireless drivers is only a small
> part of the entire effort.
>
> Beyond that is the new driver with roughly 120,000 lines of code that
> have not yet been seen by any reviewers.

120 kLOC is a lot, why is the driver so big? I would like to take a
quick look, is the code available somewhere?

-- 
Kalle Valo
