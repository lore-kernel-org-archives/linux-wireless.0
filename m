Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47718 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbeD0L06 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 07:26:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix information leak in debugfs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519044681-5663-1-git-send-email-vnaralas@codeaurora.org>
References: <1519044681-5663-1-git-send-email-vnaralas@codeaurora.org>
To: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Message-Id: <20180427112657.98754607C6@smtp.codeaurora.org> (sfid-20180427_132701_551323_A7FE8F24)
Date: Fri, 27 Apr 2018 11:26:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Venkateswara Naralasetty <vnaralas@codeaurora.org> wrote:

> During write to some of debugfs in ath10k, few variables exposing stack
> data when process user input. which leads to possible information leak.
> 
> This patch fix this issue by initializing buffer and checks
> the return valure of 'simple_write_to_buffer'.
> 
> Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

2f177c1628c3 ath10k: fix information leak in debugfs

-- 
https://patchwork.kernel.org/patch/10227751/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
