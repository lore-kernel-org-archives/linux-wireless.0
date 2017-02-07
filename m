Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:34811 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752828AbdBGFmw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 00:42:52 -0500
Received: by mail-ot0-f196.google.com with SMTP id 73so13012930otj.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2017 21:42:52 -0800 (PST)
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
Message-ID: <90709cde-bcca-eb57-3a61-4c318ed37c92@lwfinger.net> (sfid-20170207_064256_291192_B9B15061)
Date: Mon, 6 Feb 2017 23:42:50 -0600
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

I have no idea why my patches are not getting handled by patchwork, but V4 is 
not there either.

Larry
