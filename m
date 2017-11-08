Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42106 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751954AbdKHMoC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 07:44:02 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: remove redundant pointer tid_data
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171103140922.8926-1-colin.king@canonical.com>
References: <20171103140922.8926-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20171108124402.6565C60261@smtp.codeaurora.org> (sfid-20171108_134422_441907_A9D19734)
Date: Wed,  8 Nov 2017 12:44:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> tid_data is assigned but never read, hence it is redundant
> and can be removed. Cleans up clang warning:
> 
> drivers/net/wireless/realtek/rtlwifi/base.c:1581:2: warning: Value
> stored to 'tid_data' is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

82e730e521ce rtlwifi: remove redundant pointer tid_data

-- 
https://patchwork.kernel.org/patch/10040293/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
