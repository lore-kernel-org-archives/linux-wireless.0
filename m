Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60182 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753094AbdDEIAe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 04:00:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Modify macros to fix style issues
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1487751327-2917-1-git-send-email-marcin.rokicki@tieto.com>
References: <1487751327-2917-1-git-send-email-marcin.rokicki@tieto.com>
To: Marcin Rokicki <marcin.rokicki@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <50f728cb136f477986e181368592ca24@euamsexm01a.eu.qualcomm.com> (sfid-20170405_100041_731651_981D180A)
Date: Wed, 5 Apr 2017 10:00:27 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcin Rokicki <marcin.rokicki@tieto.com> wrote:
> Both macros are used internally to convert incomming parameters
> to strings in a switch case statement.
> 
> Current implementation gives following output from checkpatch.pl:
>  - ERROR: Macros with complex values should be enclosed in parentheses
>  - WARNING: Macros with flow control statements should be avoided
> 
> Fix them by modify local variable in the middle and just return at the end.
> 
> Btw add const to function that return string literals
> 
> Signed-off-by: Marcin Rokicki <marcin.rokicki@tieto.com>

I don't really see how this improves anything. We don't need to fix every
checkpatch warning as not all of them always make sense. That's why I have the
ath10k-check script so that I can disable such checkpatch warnings.

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/codingstyle#checking_code

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/9586357/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
