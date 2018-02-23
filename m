Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34392 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751557AbeBWJSV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 04:18:21 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8723be: Fix loss of signal
References: <20180222202859.16679-1-Larry.Finger@lwfinger.net>
Date: Fri, 23 Feb 2018 11:18:16 +0200
In-Reply-To: <20180222202859.16679-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Thu, 22 Feb 2018 14:28:59 -0600")
Message-ID: <87lgfkxdwn.fsf@kamboji.qca.qualcomm.com> (sfid-20180223_101831_754996_7C125584)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> In commit c713fb071edc ("rtlwifi: rtl8821ae: Fix connection lost problem
> correctly") a problem in rtl8821ae that caused loss of signal was fixed.
> That same problem has now been reported for rtl8723be. Accordingly,
> the ASPM L1 latency has been increased from 0 to 7 to fix the instability.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>
> ---
> Kalle,
>
> This patch should be sent to 4.16.

Ok, I'll queue this for 4.16.

-- 
Kalle Valo
