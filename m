Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60022 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755475AbdLGNPm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:15:42 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rtlwifi: Reduce IO in RX interrupt to boost throughput
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171113093935.20431-2-pkshih@realtek.com>
References: <20171113093935.20431-2-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <steventing@realtek.com>, <yhchuang@realtek.com>
Message-Id: <20171207131541.A22A96084A@smtp.codeaurora.org> (sfid-20171207_141613_043660_D734FB96)
Date: Thu,  7 Dec 2017 13:15:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Check remaining count of RX packets cost a lot of CPU time, so only update
> when the counter decreases to zero. In old flow, the counter was updated
> once a RX packet is received.
> 
> Signed-off-by: Steven Ting <steventing@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

3 patches applied to wireless-drivers-next.git, thanks.

fb9829e90dcd rtlwifi: Reduce IO in RX interrupt to boost throughput
dc9682a0cca5 rtlwifi: fix the wrong size to calculate fifo space
cf54622c8076 rtlwifi: cleanup the code that check whether TX ring is available

-- 
https://patchwork.kernel.org/patch/10055429/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
