Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38728 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbdFIIMv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 04:12:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: wlcore: spi: remove unnecessary variable
References: <20170609032430.GA7432@embeddedgus>
Date: Fri, 09 Jun 2017 11:12:31 +0300
In-Reply-To: <20170609032430.GA7432@embeddedgus> (Gustavo A. R. Silva's
        message of "Thu, 8 Jun 2017 22:24:30 -0500")
Message-ID: <87ink5d1g0.fsf@kamboji.qca.qualcomm.com> (sfid-20170609_101336_847576_02684CAD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <garsilva@embeddedor.com> writes:

> Remove unnecessary variable and refactor the code.
>
> Addresses-Coverity-ID: 1365000
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

I'll remove "wireless:" from the prefix.

-- 
Kalle Valo
