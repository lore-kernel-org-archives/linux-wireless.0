Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53292 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932149AbdIGM4O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 08:56:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rtlwifi: btcoexist: Fix breakage of ant_sel for rtl8723be
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170904175134.8331-2-Larry.Finger@lwfinger.net>
References: <20170904175134.8331-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>,
        Stable <stable@vger.kernel.org>
Message-Id: <20170907125614.2162060241@smtp.codeaurora.org> (sfid-20170907_145618_293260_532A53DC)
Date: Thu,  7 Sep 2017 12:56:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In commit bcd37f4a0831 ("rtlwifi: btcoex: 23b 2ant: let bt transmit when
> hw initialisation done"), there is an additional error when the module
> parameter ant_sel is used to select the auxilary antenna. The error is
> that the antenna selection is not checked when writing the antenna
> selection register.
> 
> Fixes: bcd37f4a0831 ("rtlwifi: btcoex: 23b 2ant: let bt transmit when hw initialisation done")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>
> Cc: Stable <stable@vger.kernel.org> # 4.12+

2 patches applied to wireless-drivers.git, thanks.

a33fcba6ec01 rtlwifi: btcoexist: Fix breakage of ant_sel for rtl8723be
6d6226928369 rtlwifi: btcoexist: Fix antenna selection code

-- 
https://patchwork.kernel.org/patch/9937493/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
