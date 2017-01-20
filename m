Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52554 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbdATKPe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 05:15:34 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2, 1/3] rtlwifi: Redo debugging macros RTPRINT and RT_PRINT_DATA
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170119172521.32643-2-Larry.Finger@lwfinger.net>
References: <20170119172521.32643-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Message-Id: <20170120100550.4A3B560809@smtp.codeaurora.org> (sfid-20170120_111537_040607_B8F256F6)
Date: Fri, 20 Jan 2017 10:05:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> These two debugging formss implement debugging using rather complicated
> macro constructions. These are replaced with compiled code that is easier
> to understand.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>

3 patches applied to wireless-drivers-next.git, thanks.

102e295ed5a4 rtlwifi: Redo debugging macros RTPRINT and RT_PRINT_DATA
c34df318ec9f rtlwifi: Convert COMP_XX entries into a proper debugging mask
9336d376edf1 rtlwifi: Remove debugging entry in sysfs

-- 
https://patchwork.kernel.org/patch/9526577/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
