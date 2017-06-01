Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36574 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbdFAJub (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 05:50:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [net-next] qtnfmac: remove duplicated assignment to mac
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170525134503.12106-1-colin.king@canonical.com>
References: <20170525134503.12106-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20170601095030.463D260779@smtp.codeaurora.org> (sfid-20170601_115113_248237_F2129867)
Date: Thu,  1 Jun 2017 09:50:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> mac is being assigned twice, remove redundant 2nd assignment.
> 
> Detected by CoverityScan, CID#1437554 ("Incorrect expression")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

4f8e25458cb6 qtnfmac: remove duplicated assignment to mac

-- 
https://patchwork.kernel.org/patch/9748407/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
