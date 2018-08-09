Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40080 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732368AbeHIRd7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 13:33:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] mt76x0: perform mt76x0_mac_set_ampdu_factor
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1533631417-477-1-git-send-email-sgruszka@redhat.com>
References: <1533631417-477-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-Id: <20180809150839.677E660B22@smtp.codeaurora.org> (sfid-20180809_170841_687549_19105C4A)
Date: Thu,  9 Aug 2018 15:08:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Remove return added accidentally in mt76x0_mac_set_ampdu_factor.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: a77443498137 ("mt76x0: mac files")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

1b622bd59e9f mt76x0: perform mt76x0_mac_set_ampdu_factor

-- 
https://patchwork.kernel.org/patch/10558377/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
