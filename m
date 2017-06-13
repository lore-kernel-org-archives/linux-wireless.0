Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45102 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752656AbdFMHBX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 03:01:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [-next] mwifiex: make function mwifiex_ret_pkt_aggr_ctrl static
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170602085639.29338-1-colin.king@canonical.com>
References: <20170602085639.29338-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20170613070123.14C71607E4@smtp.codeaurora.org> (sfid-20170613_090334_550132_3B600847)
Date: Tue, 13 Jun 2017 07:01:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> function mwifiex_ret_pkt_aggr_ctrl can be made static as it does not
> need to be in global scope.
> 
> Cleans up sparse warning: "symbol 'mwifiex_ret_pkt_aggr_ctrl' was not
> declared. Should it be static?"
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

292c333300ec mwifiex: make function mwifiex_ret_pkt_aggr_ctrl static

-- 
https://patchwork.kernel.org/patch/9761985/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
