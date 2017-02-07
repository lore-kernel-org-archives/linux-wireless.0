Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45542 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752782AbdBGHI3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 02:08:29 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        shaofu <shaofu@realtek.com>
Subject: Re: [PATCH 01/11 V3] rtlwifi: Fix programing CAM content sequence.
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
        <20170120212716.29887-1-Larry.Finger@lwfinger.net>
        <20170120212716.29887-1-Larry.Finger@lwfinger.net>
        <20170120212716.29887-2-Larry.Finger@lwfinger.net>
        <87bmufa3nu.fsf@codeaurora.org>
        <90709cde-bcca-eb57-3a61-4c318ed37c92@lwfinger.net>
Date: Tue, 07 Feb 2017 09:08:24 +0200
In-Reply-To: <90709cde-bcca-eb57-3a61-4c318ed37c92@lwfinger.net> (Larry
        Finger's message of "Mon, 6 Feb 2017 23:42:50 -0600")
Message-ID: <8737fq8olz.fsf@codeaurora.org> (sfid-20170207_080833_075403_016652CD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 02/06/2017 06:45 AM, Kalle Valo wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>
>>> From: Ping-Ke Shih <pkshih@realtek.com>
>>>
>>> There is a potential race condition when the control byte of a CAM
>>> entry is written first. Write in reverse order to correct the condition.
>>>
>>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>>> Signed-off-by: shaofu <shaofu@realtek.com>
>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>>> ---
>>> V2 - no changes
>>> V3 - no changes
>>
>> I missed in my reply to v2 that you had already sent v3 from this
>> patchset. Strange that I don't see this v3 patchset either in patchwork,
>> only v1.
>>
>> Try submitting v4 in case it was just a temporary glitch in patchwork.
>> But if that doesn't help I'll apply these manually.
>
> I have no idea why my patches are not getting handled by patchwork,
> but V4 is not there either.

Yeah, that's odd. I do see your patches on the mailing list so I guess
something in this set is breaking patchwork's email parser. The only
notable difference I saw that in our patches the tags were in this
format:

[PATCH 01/11 V4]

But normally we use something like this:

[PATCH V4 01/11]

I don't know if that would cause patchwork to fail and I don't really
have time to investigate it right now. I'll just apply V4 manually now
and let's hope that the problem doesn't reappear.

-- 
Kalle Valo
