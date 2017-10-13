Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33420 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbdJMJ6r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 05:58:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: Remove unused cur_rfstate variables
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1507756515-15738-1-git-send-email-chris.gekas@gmail.com>
References: <1507756515-15738-1-git-send-email-chris.gekas@gmail.com>
To: Christos Gkekas <chris.gekas@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christos Gkekas <chris.gekas@gmail.com>
Message-Id: <20171013095846.319826071B@smtp.codeaurora.org> (sfid-20171013_115931_422624_104CFE89)
Date: Fri, 13 Oct 2017 09:58:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christos Gkekas <chris.gekas@gmail.com> wrote:

> Clean up unused cur_rfstate variables in rtl8188ee, rtl8723ae, rtl8723be
> and rtl8821ae.
> 
> Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

76d7b12cbbe2 rtlwifi: Remove unused cur_rfstate variables

-- 
https://patchwork.kernel.org/patch/10000659/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
