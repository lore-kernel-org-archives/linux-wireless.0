Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33886 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729784AbeGaJEw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:04:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] atmel: Replace mdelay() with msleep() in
 probe_atmel_card()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180727084535.3848-1-baijiaju1990@gmail.com>
References: <20180727084535.3848-1-baijiaju1990@gmail.com>
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: simon@thekelleys.org.uk, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Message-Id: <20180731072556.26D726071C@smtp.codeaurora.org> (sfid-20180731_092632_413605_FE1DA533)
Date: Tue, 31 Jul 2018 07:25:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> probe_atmel_card() is never called in atomic context.
> It calls mdelay() to busily wait, which is not necessary.
> mdelay() can be replaced with msleep().
> 
> This is found by a static analysis tool named DCNS written by myself.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

5685bee313e9 atmel: Replace mdelay() with msleep() in probe_atmel_card()

-- 
https://patchwork.kernel.org/patch/10546747/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
