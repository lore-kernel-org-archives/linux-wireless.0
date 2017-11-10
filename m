Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755635AbdKJCg4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 21:36:56 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rsi: rsi_91x_ps: remove redundant code in str_psstate
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171106215321.GA25539@embeddedor.com>
References: <20171106215321.GA25539@embeddedor.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-Id: <20171110023656.2C103601D1@smtp.codeaurora.org> (sfid-20171110_033717_153540_1556A97F)
Date: Fri, 10 Nov 2017 02:36:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <garsilva@embeddedor.com> wrote:

> "INVALID_STATE" is already being returned in the default case and this
> code cannot be reached.
> 
> Addresses-Coverity-ID: 1398384
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

4775ae7afec6 rsi: rsi_91x_ps: remove redundant code in str_psstate

-- 
https://patchwork.kernel.org/patch/10044571/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
