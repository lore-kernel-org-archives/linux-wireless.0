Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56504 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbeGaI4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:56:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] airo: remove unused variables len and dev and clean
 upformatting
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180709133843.15615-1-colin.king@canonical.com>
References: <20180709133843.15615-1-colin.king@canonical.com>
To: Colin King <colin.king@canonical.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180731071739.6A3D8606AC@smtp.codeaurora.org> (sfid-20180731_091859_761867_065CEBEB)
Date: Tue, 31 Jul 2018 07:17:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variables len and dev assigned values but are never used hence they
> are redundant and can be removed.  Also add in white space in for-loop
> and remove some { } braces on if statement.
> 
> Cleans up clang warnings:
> warning: variable 'len' set but not used [-Wunused-but-set-variable]
> warning: variable 'dev' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

d01a4e04dab7 airo: remove unused variables len and dev and clean up formatting

-- 
https://patchwork.kernel.org/patch/10514607/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
