Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48240 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750982AbcKSHYr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Nov 2016 02:24:47 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8723be: Fix bug in ant_sel code from commit
 c18d8f509571
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161117180533.16136-1-Larry.Finger@lwfinger.net>
References: <20161117180533.16136-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Message-Id: <20161119072446.DDD3E6120F@smtp.codeaurora.org> (sfid-20161119_082451_880469_565D22BF)
Date: Sat, 19 Nov 2016 07:24:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> In commit c18d8f509571 ("rtlwifi: rtl8723be: Add antenna select module
> parameter"), wifi was fixed for those laptops that have only a single
> antenna but have an incorrectly coded EEPROM. This error causes the
> driver to select the wrong antenna. In that commit, one necessary change
> that affects Bluetooth operation was missed.
> 
> Fixes: c18d8f509571 ("rtlwifi: rtl8723be: Add antenna select module parameter")
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Requested by Larry

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9434985/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
