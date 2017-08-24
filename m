Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60306 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752841AbdHXJwp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 05:52:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: btcoex: 23b 1ant: fix duplicated code for different
 branches
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170818002219.GA9475@embeddedgus>
References: <20170818002219.GA9475@embeddedgus>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20170824095244.AFA9F60714@smtp.codeaurora.org> (sfid-20170824_115316_727553_96EDDF14)
Date: Thu, 24 Aug 2017 09:52:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Refactor code in order to avoid identical code for different branches.
> 
> This issue was detected with the help of Coccinelle.
> 
> Addresses-Coverity-ID: 1415177
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

14cc696c0a4a rtlwifi: btcoex: 23b 1ant: fix duplicated code for different branches

-- 
https://patchwork.kernel.org/patch/9907397/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
