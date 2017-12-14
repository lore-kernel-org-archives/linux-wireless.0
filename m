Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45896 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdLNMnX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:43:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rtlwifi: rtl_pci: 8822BE puts broadcast and multicast
 packet to HIQ
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171209173710.9879-2-Larry.Finger@lwfinger.net>
References: <20171209173710.9879-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20171214124323.6FCF560A3B@smtp.codeaurora.org> (sfid-20171214_134327_489242_9A5AB669)
Date: Thu, 14 Dec 2017 12:43:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Making this change to HIQ, which has high priority, improves the response
> time for transmission after TBTT or beacon.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

2 patches applied to wireless-drivers-next.git, thanks.

e298be2a97fd rtlwifi: rtl_pci: 8822BE puts broadcast and multicast packet to HIQ
b7573a0a27bf rtlwifi: rtl_pci: Fix the bug when inactiveps is enabled.

-- 
https://patchwork.kernel.org/patch/10103759/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
