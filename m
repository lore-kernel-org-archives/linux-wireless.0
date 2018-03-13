Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39100 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932909AbeCMQn1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:43:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rsi: improve RX handling in SDIO interface
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519803508-27737-2-git-send-email-amitkarwar@gmail.com>
References: <1519803508-27737-2-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20180313164327.32A0760848@smtp.codeaurora.org> (sfid-20180313_174339_487844_C35C9143)
Date: Tue, 13 Mar 2018 16:43:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> 
> Currently, RX packets are handled in interrupt context in SDIO
> interface. To improve the efficiency of processing RX packets,
> RX thread and RX skb queues are introduced.
> When the packet is read from device, driver prepares skb, add to
> RX queue and trigger RX thread event. RX thread processes the
> packets from RX queue.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

3 patches applied to wireless-drivers-next.git, thanks.

50117605770c rsi: improve RX handling in SDIO interface
8809f08cdc0b rsi: use dynamic RX control blocks instead of MAX_RX_URB
a1854fae1414 rsi: improve RX packet handling in USB interface

-- 
https://patchwork.kernel.org/patch/10246955/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
