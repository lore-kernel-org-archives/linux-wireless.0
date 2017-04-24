Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:7200 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164613AbdDXD4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Apr 2017 23:56:31 -0400
Date: Sun, 23 Apr 2017 20:49:43 -0700
From: Jakub Kicinski <kubakici@wp.pl>
To: Pan Bian <bianpan2016@163.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 1/1] mt7601u: check return value of alloc_skb
Message-ID: <20170423204943.3ce98a63@laptop> (sfid-20170424_055635_698461_A8CE9ECE)
In-Reply-To: <1492930823-17249-1-git-send-email-bianpan2016@163.com>
References: <1492930823-17249-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 23 Apr 2017 15:00:23 +0800, Pan Bian wrote:
> Function alloc_skb() will return a NULL pointer if there is no enough
> memory. However, in function mt7601u_mcu_msg_alloc(), its return value
> is not validated before it is used. This patch fixes it.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>

Thanks!
