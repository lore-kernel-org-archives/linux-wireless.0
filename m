Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39088 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbdDTE7Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 00:59:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH 00/14] rtlwifi: btcoex: Second set of changes for rtl8821ae 2ant
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Date: Thu, 20 Apr 2017 07:59:18 +0300
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Sat, 15 Apr 2017 15:31:46 -0500")
Message-ID: <87zifb65eh.fsf@codeaurora.org> (sfid-20170420_065946_810396_9985E0BA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> These patches are the second set of patches for file
> btcoexist/halbtc8821a2ant.c.
>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

BTW, please try to limit the amount of patches you send. I haven't
counted how many rtlwifi patches there are from the last week but it's
just too much, even if they are in smaller sets like this one. Reviewing
them is just too tedious when you see that you have something like 50
more still to go.

If you send two sets with reasonable size[1] per week I don't have any
problems. But if you send five such sets per week I will get annoyed :)
So try to strect the submission a bit to stay below ~30 patches per week
limit, please.

So I'm not sure if I'm able to apply all of pending rtlwifi patches
before the merge window opens, but I'll try.

[1] a reasonable size is around a dozen patches per set

-- 
Kalle Valo
