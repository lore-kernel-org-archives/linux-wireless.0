Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35130 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbbKLV3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 16:29:22 -0500
Received: by obbnk6 with SMTP id nk6so57392566obb.2
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 13:29:22 -0800 (PST)
Subject: Re: [PATCH] realtek: rtlwifi: rtl8821ae: Fix lockups on boot
To: Kalle Valo <kvalo@codeaurora.org>
References: <1447173971-15311-1-git-send-email-Larry.Finger@lwfinger.net>
 <87a8qj56yz.fsf@kamboji.qca.qualcomm.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <564504AF.5030201@lwfinger.net> (sfid-20151112_222926_560117_48FFA712)
Date: Thu, 12 Nov 2015 15:29:19 -0600
MIME-Version: 1.0
In-Reply-To: <87a8qj56yz.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2015 01:54 PM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> In commit 54328e64047a5 ("rtlwifi: rtl8821ae: Fix system lockups on boot"),
>> an attempt was made to fix a regression introduced in commit 1277fa2ab2f9
>> ("rtlwifi: Remove the clear interrupt routine from all drivers").
>> Unfortunately, there were logic errors in that patch that prevented
>> affected boxes from booting even after that patch was applied.
>>
>> The actual cause of the original problem is unknown as none of the
>> developers have systems that are affected.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org> [V4.1+]
>
> I think the "realtek:" prefix is superfluous, "rtlwifi:" should be
> enough. I'll also add a fixes line before I commit this:
>
> Fixes: 54328e64047a ("rtlwifi: rtl8821ae: Fix system lockups on boot")

I'll drop the extra prefix in the future. Your extra line is good.

Larry


