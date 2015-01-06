Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:48937 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbbAFIKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 03:10:33 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 23/23 V2 for 3.19]  rtlwifi: Fix error when accessing unmapped memory in skb
References: <1419711457-21469-1-git-send-email-Larry.Finger@lwfinger.net>
	<87a928726w.fsf@kamboji.qca.qualcomm.com>
	<549FA005.7050802@lwfinger.net>
	<87387p4m89.fsf@kamboji.qca.qualcomm.com>
	<54AB0145.3070601@lwfinger.net>
Date: Tue, 06 Jan 2015 10:10:26 +0200
In-Reply-To: <54AB0145.3070601@lwfinger.net> (Larry Finger's message of "Mon,
	05 Jan 2015 15:25:25 -0600")
Message-ID: <871tn81g99.fsf@kamboji.qca.qualcomm.com> (sfid-20150106_091036_344663_B9AF5BCE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 01/05/2015 03:20 AM, Kalle Valo wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>
>>>> 23/23? Where are patches 1-22? I don't see them in patchwork:
>>>>
>>>> https://patchwork.kernel.org/project/linux-wireless/list/
>>>
>>> Sorry. I forgot to edit the subject line. To get git to format that
>>> one patch, I had to generate a total of 23. There is only 1 of 1 that
>>> will be submitted.
>>
>> Ok, I was just worried that I had missed the other 22. But you can
>> actually get a single commit like this so no editing is needed:
>>
>> git format-patch -1 2a3e60d37fc6
>
> Thanks for the git lesson. Some week^H^H^H^Hmonth I should learn to
> use more parts of that tool, but you know how that goes.

I have the exactly same situation with python :)

> I do have an additional question on procedure. If I submit a number of
> patches in a series, but find that only one of the series needs a V2.
> Is it better to resubmit all N of them, or only just the one that
> needs changing?

Please resubmit the whole series. It's just so much easier and more
reliable for me to handle changes that way.

-- 
Kalle Valo
