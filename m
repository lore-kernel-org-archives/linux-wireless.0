Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40926 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbdHHLpk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:45:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rsi: fix uninitialized descriptor pointer issue
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1501770400-6659-1-git-send-email-amitkarwar@gmail.com>
References: <1501770400-6659-1-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20170808114539.B98E560241@smtp.codeaurora.org> (sfid-20170808_134543_187851_B01F3E83)
Date: Tue,  8 Aug 2017 11:45:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> 
> This patch fixes the uninitialized descriptor pointer
> issue in function rsi_send_internal_mgmt_frame().
> Descriptor should point to start of the skb data.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 9a629fafe7d8 ("rsi: immediate wakeup bit and priority for TX command packets")
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Patch applied to wireless-drivers-next.git, thanks.

6345016d4bea rsi: fix uninitialized descriptor pointer issue

-- 
https://patchwork.kernel.org/patch/9879245/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
