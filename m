Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34868 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdBGIGV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 03:06:21 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 1/7] rtlwifi: rtl8821ae: Fix typo in symbol for bandwidth numbers
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170203173521.6635-2-Larry.Finger@lwfinger.net>
References: <20170203173521.6635-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Message-Id: <20170207080620.ADAB960A1B@smtp.codeaurora.org> (sfid-20170207_090624_241443_8FE3793A)
Date: Tue,  7 Feb 2017 08:06:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In several places, "BANDWITH" is used when "BANDWIDTH" should have been
> used.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>

7 patches applied to wireless-drivers-next.git, thanks.

d5e582523aea rtlwifi: rtl8821ae: Fix typo in symbol for bandwidth numbers
258b93cc391b rtlwifi: btcoexist: Convert halbtc8192e2ant.c to use standard debugging
dd192494e6ed rtlwifi: btcoexist: Convert halbtc8723b1ant.c to use standard debugging
2277f5f1154a rtlwifi: btcoexist: Convert halbtc8723b2ant.c to use standard debugging
bed4ff58af9d rtlwifi: btcoexist: Convert halbtc8821a1ant.c to use standard debugging
10468c3b438c rtlwifi: btcoexist: Convert halbtc8821a2ant.c to use standard debugging
41880bb38a55 rtlwifi: btcoexist: Convert halbtcoutsrc.c to use standard debugging

-- 
https://patchwork.kernel.org/patch/9554749/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
