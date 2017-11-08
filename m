Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52314 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752365AbdKHMux (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 07:50:53 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlegacy: remove redundant pointer sta_priv
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171101092622.16625-1-colin.king@canonical.com>
References: <20171101092622.16625-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20171108125052.F00B3607E1@smtp.codeaurora.org> (sfid-20171108_135112_648834_312EB134)
Date: Wed,  8 Nov 2017 12:50:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer sta_priv is assigned but never read, hence it is redundant
> and can be removed. Cleans up clang warning:
> 
> drivers/net/wireless/intel/iwlegacy/4965-rs.c:2163:2: warning: Value
> stored to 'sta_priv' is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

6c6e25311312 iwlegacy: remove redundant pointer sta_priv

-- 
https://patchwork.kernel.org/patch/10036047/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
