Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44695 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753290AbcJEQFu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 12:05:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [-next] wlcore: sdio: drop kfree for memory allocated with
 devm_kzalloc
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1475073516-7328-1-git-send-email-weiyj.lk@gmail.com>
References: <1475073516-7328-1-git-send-email-weiyj.lk@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Bruno Herrera <bruherrera@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20161005160549.BC13961B13@smtp.codeaurora.org> (sfid-20161005_180554_129078_9D92E3C4)
Date: Wed,  5 Oct 2016 16:05:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> It's not necessary to free memory allocated with devm_kzalloc
> and using kfree leads to a double free.
> 
> Fixes: d776fc86b82f ("wlcore: sdio: Populate config firmware data")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Patch applied to wireless-drivers.git, thanks.

f38b7c254753 wlcore: sdio: drop kfree for memory allocated with devm_kzalloc

-- 
https://patchwork.kernel.org/patch/9353985/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
