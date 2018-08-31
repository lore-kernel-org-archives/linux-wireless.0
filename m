Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58906 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbeHaTv6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:51:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] libertas_tf: prevent underflow in process_cmdrequest()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180814090747.a7gcph2wa6abyimi@kili.mountain>
References: <20180814090747.a7gcph2wa6abyimi@kili.mountain>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20180831154353.A86F3606CF@smtp.codeaurora.org> (sfid-20180831_174416_288666_A46BD721)
Date: Fri, 31 Aug 2018 15:43:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> If recvlength is less than MESSAGE_HEADER_LEN (4) we would end up
> corrupting memory.
> 
> Fixes: c305a19a0d0a ("libertas_tf: usb specific functions")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied to wireless-drivers-next.git, thanks.

3348ef6a6a12 libertas_tf: prevent underflow in process_cmdrequest()

-- 
https://patchwork.kernel.org/patch/10565197/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
