Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:32927 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbbAEVZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 16:25:27 -0500
Received: by mail-oi0-f47.google.com with SMTP id v63so49655195oia.6
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2015 13:25:26 -0800 (PST)
Message-ID: <54AB0145.3070601@lwfinger.net> (sfid-20150105_222540_428339_220A30C5)
Date: Mon, 05 Jan 2015 15:25:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 23/23 V2 for 3.19]  rtlwifi: Fix error when accessing
 unmapped memory in skb
References: <1419711457-21469-1-git-send-email-Larry.Finger@lwfinger.net>	<87a928726w.fsf@kamboji.qca.qualcomm.com>	<549FA005.7050802@lwfinger.net> <87387p4m89.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87387p4m89.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2015 03:20 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>>> 23/23? Where are patches 1-22? I don't see them in patchwork:
>>>
>>> https://patchwork.kernel.org/project/linux-wireless/list/
>>
>> Sorry. I forgot to edit the subject line. To get git to format that
>> one patch, I had to generate a total of 23. There is only 1 of 1 that
>> will be submitted.
>
> Ok, I was just worried that I had missed the other 22. But you can
> actually get a single commit like this so no editing is needed:
>
> git format-patch -1 2a3e60d37fc6

Thanks for the git lesson. Some week^H^H^H^Hmonth I should learn to use more 
parts of that tool, but you know how that goes.

I do have an additional question on procedure. If I submit a number of patches 
in a series, but find that only one of the series needs a V2. Is it better to 
resubmit all N of them, or only just the one that needs changing?

Thanks,

Larry


