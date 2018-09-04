Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48414 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbeIDMky (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 08:40:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] wireless: remove unnecessary unlikely()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180831150300.2702-1-igor.stoppa@huawei.com>
References: <20180831150300.2702-1-igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: igor.stoppa@gmail.com, Igor Stoppa <igor.stoppa@huawei.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Message-Id: <20180904081652.BD776607B9@smtp.codeaurora.org> (sfid-20180904_101705_271315_4EE28DF6)
Date: Tue,  4 Sep 2018 08:16:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Stoppa <igor.stoppa@gmail.com> wrote:

> Both WARN_ON() and WARN_ON_ONCE() already contain unlikely().
> 
> Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

7e41fb504592 wireless: remove unnecessary unlikely()

-- 
https://patchwork.kernel.org/patch/10583997/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
