Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48048 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934363AbeEIKYB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 06:24:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: remove duplicate definition of antenna number for btcoex
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180504024204.6138-1-pkshih@realtek.com>
References: <20180504024204.6138-1-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Message-Id: <20180509102400.E266B60386@smtp.codeaurora.org> (sfid-20180509_122412_159512_B0D03AF6)
Date: Wed,  9 May 2018 10:24:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Two enumerations bt_total_ant_num and bt_ant_num are identical, so one
> can be removed.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

bf516e7d8b1c rtlwifi: remove duplicate definition of antenna number for btcoex

-- 
https://patchwork.kernel.org/patch/10379701/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
