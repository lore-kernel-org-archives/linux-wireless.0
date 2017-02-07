Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:35275 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdBGD3w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 22:29:52 -0500
Received: by mail-ot0-f194.google.com with SMTP id 65so12745291otq.2
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2017 19:29:51 -0800 (PST)
Subject: Re: [PATCH 01/11 V3] rtlwifi: Fix programing CAM content sequence.
To: Kalle Valo <kvalo@codeaurora.org>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
 <20170120212716.29887-1-Larry.Finger@lwfinger.net>
 <20170120212716.29887-1-Larry.Finger@lwfinger.net>
 <20170120212716.29887-2-Larry.Finger@lwfinger.net>
 <87bmufa3nu.fsf@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        shaofu <shaofu@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <00451ab5-c356-0466-e501-6e08f3839201@lwfinger.net> (sfid-20170207_042956_362509_B057CD57)
Date: Mon, 6 Feb 2017 21:29:49 -0600
MIME-Version: 1.0
In-Reply-To: <87bmufa3nu.fsf@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2017 06:45 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> From: Ping-Ke Shih <pkshih@realtek.com>
>>
>> There is a potential race condition when the control byte of a CAM
>> entry is written first. Write in reverse order to correct the condition.
>>
>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>> Signed-off-by: shaofu <shaofu@realtek.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>> V2 - no changes
>> V3 - no changes
>
> I missed in my reply to v2 that you had already sent v3 from this
> patchset. Strange that I don't see this v3 patchset either in patchwork,
> only v1.
>
> Try submitting v4 in case it was just a temporary glitch in patchwork.
> But if that doesn't help I'll apply these manually.

I have no idea why that patchsets are missing. I will send V4 shortly.

Sorry I did not respond more quickly. I was out of my office today.

Larry
