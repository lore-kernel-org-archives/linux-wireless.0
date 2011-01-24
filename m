Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59915 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1AXURL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 15:17:11 -0500
Subject: Re: [PATCH v2] wl12xx: fix some endianess bugs
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295168830-4637-1-git-send-email-eliad@wizery.com>
References: <1295168830-4637-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 22:17:20 +0200
Message-ID: <1295900240.2063.1.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-16 at 10:07 +0100, Eliad Peller wrote:
> pointed out by sparse warnings:
> 
>   CHECK   drivers/net/wireless/wl12xx/cmd.c
> drivers/net/wireless/wl12xx/cmd.c:987:20: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/wl12xx/cmd.c:987:20:    expected restricted __le16 [usertype] aging_period
> drivers/net/wireless/wl12xx/cmd.c:987:20:    got int
>   CHECK   drivers/net/wireless/wl12xx/tx.c
> drivers/net/wireless/wl12xx/tx.c:197:2: warning: cast from restricted __le16
> drivers/net/wireless/wl12xx/tx.c:197:2: warning: cast from restricted __le16
> drivers/net/wireless/wl12xx/tx.c:197:2: warning: cast from restricted __le16
>   CHECK   drivers/net/wireless/wl12xx/acx.c
> drivers/net/wireless/wl12xx/acx.c:816:23: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/wl12xx/acx.c:816:23:    expected restricted __le32 [usertype] rate_policy_idx
> drivers/net/wireless/wl12xx/acx.c:816:23:    got unsigned char [unsigned] [usertype] idx
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thank you!

-- 
Cheers,
Luca.

