Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45804 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751493AbcL3NMx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 08:12:53 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/7] rtlwifi: btcoexist: Update routines for RTL8192EE
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161203173207.17774-2-Larry.Finger@lwfinger.net>
References: <20161203173207.17774-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20161230131252.983096137F@smtp.codeaurora.org> (sfid-20161230_141256_033755_46C5299F)
Date: Fri, 30 Dec 2016 13:12:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> The btcoexist routines for the RTL8192EE have been extensively rewritten.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Dropped per Larry's request.

7 patches set to Changes Requested.

9459709 [1/7] rtlwifi: btcoexist: Update routines for RTL8192EE
9459711 [2/7] rtlwifi: btcoexist: Rewrite halbtc8723b1ant code
9459719 [3/7] rtlwifi: btcoexist: Rewrite of halbtc8723b2ant
9459717 [4/7] rtlwifi: btcoexist: Rewrite routine halbtc8821a1ant
9459721 [5/7] rtlwifi: btcoexist: Rewrite routine halbtc8821a2ant
9459713 [6/7] rtlwifi: Add btcoex record_pwr_mode
9459715 [7/7] rtlwifi: btcoexist control to enter/leave LPS

-- 
https://patchwork.kernel.org/patch/9459709/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
