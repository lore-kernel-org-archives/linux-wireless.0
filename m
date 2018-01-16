Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56654 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbeAPOeY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:34:24 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: remove redundant -ve check against u32 integer size
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180112172713.28252-1-colin.king@canonical.com>
References: <20180112172713.28252-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180116143424.26848602BA@smtp.codeaurora.org> (sfid-20180116_153441_607251_9815836A)
Date: Tue, 16 Jan 2018 14:34:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> Variable section_table.size is a u32 and so cannot be less than
> zero, hence the less than zero check is redundant and can be
> removed.
> 
> Detected by CoverityScan, CID#1463855 ("Unsigned compared against 0")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

95f27a51ee02 ath10k: remove redundant -ve check against u32 integer size

-- 
https://patchwork.kernel.org/patch/10161483/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
