Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48720 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbeH1PKm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 11:10:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: wireless: ath: Convert to using %pOFn instead of device_node.name
References: <20180828015252.28511-1-robh@kernel.org>
        <20180828015252.28511-36-robh@kernel.org>
Date: Tue, 28 Aug 2018 14:19:27 +0300
In-Reply-To: <20180828015252.28511-36-robh@kernel.org> (Rob Herring's message
        of "Mon, 27 Aug 2018 20:52:37 -0500")
Message-ID: <87h8jeg2m8.fsf@kamboji.qca.qualcomm.com> (sfid-20180828_132010_336905_4AD39CEE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rob Herring <robh@kernel.org> writes:

> In preparation to remove the node name pointer from struct device_node,
> convert printf users to use the %pOFn format specifier.
>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/net/wireless/ath/ath6kl/init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

The correct prefix is "ath6kl:" but I can fix that.

-- 
Kalle Valo
