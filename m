Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39502 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1434939AbdDZJDH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 05:03:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] mt7601u: check return value of alloc_skb
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1492930823-17249-1-git-send-email-bianpan2016@163.com>
References: <1492930823-17249-1-git-send-email-bianpan2016@163.com>
To: Pan Bian <bianpan2016@163.com>
Cc: Jakub Kicinski <kubakici@wp.pl>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Pan Bian <bianpan2016@163.com>
Message-Id: <20170426090305.4C13361496@smtp.codeaurora.org> (sfid-20170426_112851_640036_E89D0AB4)
Date: Wed, 26 Apr 2017 09:03:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pan Bian <bianpan2016@163.com> wrote:
> Function alloc_skb() will return a NULL pointer if there is no enough
> memory. However, in function mt7601u_mcu_msg_alloc(), its return value
> is not validated before it is used. This patch fixes it.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

5fb01e91daf8 mt7601u: check return value of alloc_skb

-- 
https://patchwork.kernel.org/patch/9694549/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
