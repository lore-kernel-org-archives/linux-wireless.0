Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1432985AbdDZI6d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 04:58:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8821ae: setup 8812ae RFE according to device type
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170417003207.32347-1-Larry.Finger@lwfinger.net>
References: <20170417003207.32347-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Maxim Samoylov <max7255@gmail.com>,
        Stable <stable@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170426085832.79D0E61493@smtp.codeaurora.org> (sfid-20170426_110239_260865_7B139B86)
Date: Wed, 26 Apr 2017 08:58:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Current channel switch implementation sets 8812ae RFE reg value assuming
> that device always has type 2.
> 
> Extend possible RFE types set and write corresponding reg values.
> 
> Source for new code is
> http://dlcdnet.asus.com/pub/ASUS/wireless/PCE-AC51/DR_PCE_AC51_20232801152016.zip
> 
> Signed-off-by: Maxim Samoylov <max7255@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

46cfa2148e73 rtlwifi: rtl8821ae: setup 8812ae RFE according to device type

-- 
https://patchwork.kernel.org/patch/9683395/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
