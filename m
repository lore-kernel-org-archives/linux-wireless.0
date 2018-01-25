Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33316 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeAYRes (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 12:34:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: btcoex: Fix some static warnings from Sparse
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180125024954.3720-1-pkshih@realtek.com>
References: <20180125024954.3720-1-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Message-Id: <20180125173448.7B6BD60590@smtp.codeaurora.org> (sfid-20180125_183452_783414_ABE3532C)
Date: Thu, 25 Jan 2018 17:34:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Add 'static' or declaration to resolve the warnings, and remove two unused
> functions halbtc_set_macreg() and halbtc_get_macreg() exposed when they
> were made static.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

f2f6026af7a8 rtlwifi: btcoex: Fix some static warnings from Sparse

-- 
https://patchwork.kernel.org/patch/10183489/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
