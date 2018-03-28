Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49788 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753629AbeC1OfW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 10:35:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/9] rtlwifi: btcoex: Add modifier const to version related variables
References: <20180328072741.23349-1-pkshih@realtek.com>
        <20180328072741.23349-8-pkshih@realtek.com>
Date: Wed, 28 Mar 2018 17:35:17 +0300
In-Reply-To: <20180328072741.23349-8-pkshih@realtek.com> (pkshih@realtek.com's
        message of "Wed, 28 Mar 2018 15:27:39 +0800")
Message-ID: <87370knu8q.fsf@kamboji.qca.qualcomm.com> (sfid-20180328_163525_925094_CC5C0568)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<pkshih@realtek.com> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> The variables declared as 'static' look a little weird. Since they are
> version of btcoex and only used to display in debug message, this patch
> changes them to 'static const' to make it clear.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

That's a good idea, thanks.

-- 
Kalle Valo
