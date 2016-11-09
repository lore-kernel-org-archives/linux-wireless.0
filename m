Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59534 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbcKIBek (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 20:34:40 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [-next] mwifiex: fix missing destroy_workqueue() on error in
 mwifiex_add_virtual_intf()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1475161076-1409-1-git-send-email-weiyj.lk@gmail.com>
References: <1475161076-1409-1-git-send-email-weiyj.lk@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20161109013440.18D63611CB@smtp.codeaurora.org> (sfid-20161109_023443_636073_E4F57373)
Date: Wed,  9 Nov 2016 01:34:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Add the missing destroy_workqueue() before return from
> mwifiex_add_virtual_intf() in the error handling case.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

424342ff0e03 mwifiex: fix missing destroy_workqueue() on error in mwifiex_add_virtual_intf()

-- 
https://patchwork.kernel.org/patch/9356567/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
