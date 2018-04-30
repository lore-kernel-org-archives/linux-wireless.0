Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59902 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbeD3KXc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 06:23:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: fix mwifiex_hard_start_xmit()'s return type
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180424131802.4913-1-luc.vanoostenryck@gmail.com>
References: <20180424131802.4913-1-luc.vanoostenryck@gmail.com>
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Message-Id: <20180430102331.C959D60710@smtp.codeaurora.org> (sfid-20180430_122351_148116_56F1B18B)
Date: Mon, 30 Apr 2018 10:23:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luc Van Oostenryck <luc.vanoostenryck@gmail.com> wrote:

> The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
> which is a typedef for an enum type, but the implementation in this
> driver returns an 'int'.
> 
> Fix this by returning 'netdev_tx_t' in this driver too.
> 
> Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

c126e1995f79 mwifiex: fix mwifiex_hard_start_xmit()'s return type

-- 
https://patchwork.kernel.org/patch/10359857/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
