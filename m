Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41054 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755651AbdCTQwd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 12:52:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: atmel: remove time_t usage
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170223161445.19200-1-alexandre.belloni@free-electrons.com>
References: <20170223161445.19200-1-alexandre.belloni@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Simon Kelley <simon@thekelleys.org.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Message-Id: <20170320164337.CC0E1601A1@smtp.codeaurora.org> (sfid-20170320_175312_092721_C30C7FB2)
Date: Mon, 20 Mar 2017 16:43:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> last_qual never really holds a time. It only holds jiffies. Make it the
> same type as jiffies.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Patch applied to wireless-drivers-next.git, thanks.

5c5105666de5 atmel: remove time_t usage

-- 
https://patchwork.kernel.org/patch/9588521/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
