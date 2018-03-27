Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47328 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751192AbeC0Ixk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 04:53:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [next] rsi: remove redundant duplicate assignment of buffer_size
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180314141239.8321-1-colin.king@canonical.com>
References: <20180314141239.8321-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180327085340.1059260251@smtp.codeaurora.org> (sfid-20180327_105406_185454_FBAD1D65)
Date: Tue, 27 Mar 2018 08:53:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable buffer_size is re-assigned the same value, this duplicated
> assignment is redundant and can be removed.
> 
> Cleans up clang warning:
> drivers/net/wireless/rsi/rsi_91x_usb.c:140:4: warning: Value stored
> to 'buffer_size' is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

a31f9314114c rsi: remove redundant duplicate assignment of buffer_size

-- 
https://patchwork.kernel.org/patch/10282247/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
