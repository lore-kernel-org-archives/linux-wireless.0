Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46546 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751978AbdCHPNq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 10:13:46 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wireless/atmel: remove time_t usage
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170223161445.19200-1-alexandre.belloni@free-electrons.com>
References: <20170223161445.19200-1-alexandre.belloni@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Simon Kelley <simon@thekelleys.org.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Message-Id: <20170308151340.7FE4E60793@smtp.codeaurora.org> (sfid-20170308_161443_732998_57F74406)
Date: Wed,  8 Mar 2017 15:13:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> last_qual never really holds a time. It only holds jiffies. Make it the
> same type as jiffies.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

The title should start with "atmel:", I can fix that during commit.

-- 
https://patchwork.kernel.org/patch/9588521/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
