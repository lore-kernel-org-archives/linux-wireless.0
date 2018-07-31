Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbeGaJAJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:00:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 03/10] atmel: hide unused procfs helpers
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180713064658.10340-1-yuehaibing@huawei.com>
References: <20180713064658.10340-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <simon@thekelleys.org.uk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180731072114.7D47B60708@smtp.codeaurora.org> (sfid-20180731_092319_631910_985829D8)
Date: Tue, 31 Jul 2018 07:21:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> When CONFIG_PROC_FS isn't set, gcc warning this:
> 
> drivers/net/wireless/atmel/atmel.c:1402:12: warning: ‘atmel_proc_show’ defined but not used [-Wunused-function]
>  static int atmel_proc_show(struct seq_file *m, void *v)
>             ^
> fix this by adding #ifdef around it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

8b8f3278d241 atmel: hide unused procfs helpers

-- 
https://patchwork.kernel.org/patch/10522647/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
