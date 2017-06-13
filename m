Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47952 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752507AbdFMHHL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 03:07:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore: spi: remove unnecessary variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170609032430.GA7432@embeddedgus>
References: <20170609032430.GA7432@embeddedgus>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-Id: <20170613070710.ED647601D9@smtp.codeaurora.org> (sfid-20170613_090810_808879_E32C2858)
Date: Tue, 13 Jun 2017 07:07:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <garsilva@embeddedor.com> wrote:

> Remove unnecessary variable and refactor the code.
> 
> Addresses-Coverity-ID: 1365000
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

c48c281e7236 wlcore: spi: remove unnecessary variable

-- 
https://patchwork.kernel.org/patch/9777073/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
