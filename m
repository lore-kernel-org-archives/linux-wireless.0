Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53798 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbeBYHsB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Feb 2018 02:48:01 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8723be: Fix loss of signal
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180222202859.16679-1-Larry.Finger@lwfinger.net>
References: <20180222202859.16679-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Message-Id: <20180225074801.365E16095F@smtp.codeaurora.org> (sfid-20180225_084805_075819_84BBC4AB)
Date: Sun, 25 Feb 2018 07:48:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In commit c713fb071edc ("rtlwifi: rtl8821ae: Fix connection lost problem
> correctly") a problem in rtl8821ae that caused loss of signal was fixed.
> That same problem has now been reported for rtl8723be. Accordingly,
> the ASPM L1 latency has been increased from 0 to 7 to fix the instability.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>
> Tested-by: James Cameron <quozl@laptop.org>

Patch applied to wireless-drivers.git, thanks.

78dc897b7ee6 rtlwifi: rtl8723be: Fix loss of signal

-- 
https://patchwork.kernel.org/patch/10236349/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
