Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752281AbdKHMpR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 07:45:17 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: remove redundant initialization to cfg_cmd
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171104193759.919-1-colin.king@canonical.com>
References: <20171104193759.919-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20171108124517.3D1E2607A4@smtp.codeaurora.org> (sfid-20171108_134537_972318_6EFC95A0)
Date: Wed,  8 Nov 2017 12:45:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> cfg_cmd is initialized to zero and this value is never read, instead
> it is over-written in the start of a do-while loop. Remove the
> redundant initialization. Cleans up clang warning:
> 
> drivers/net/wireless/realtek/rtlwifi/core.c:1750:22: warning: Value
> stored to 'cfg_cmd' during its initialization is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

f80ead1cd5fa rtlwifi: remove redundant initialization to cfg_cmd

-- 
https://patchwork.kernel.org/patch/10041685/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
