Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36143 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbbJFPPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 11:15:12 -0400
Received: by obcgx8 with SMTP id gx8so156385939obc.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2015 08:15:12 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: rtl818x: Move drivers into new realtek directory
To: Kalle Valo <kvalo@codeaurora.org>
References: <1441659556-20344-1-git-send-email-Larry.Finger@lwfinger.net>
 <87io6k12o1.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, shaofu <shaofu@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5613E57D.3090101@lwfinger.net> (sfid-20151006_171517_086788_D309E701)
Date: Tue, 6 Oct 2015 10:15:09 -0500
MIME-Version: 1.0
In-Reply-To: <87io6k12o1.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2015 09:39 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> Now that a new mac80211-based driver for Realtek devices has been submitted,
>> it is time to reorganize the directories. Rather than having directories
>> rtlwifi and rtl818x be in drivers/net/wireless/, they will now be in
>> drivers/net/wireless/realtek/. This change simplifies the directory
>> structure, but does not result in any configuration changes that are
>> visable to the user.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>> Kalle,
>>
>> This patch was generated aginst the pending branch of the wireless-drivers-next
>> git tree.
>
> Actually I prefer to use the master branch as the baseline for new
> patches (I always rebase the pending branch) and because of that there
> was a small conflict in drivers/net/wireless/Kconfig. Also I did a small
> whitespace fix to realtek/rtlwifi/Kconfig. Please double check my
> changes before I commit this:
>
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?h=pending&id=38d9ef794a3edee89c6001e576ca9000db1a19d8

Sorry about misinterpreting which tree to change. Your fixes look fine to me.

Thanks,

Larry


