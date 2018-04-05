Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53422 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbeDEMj4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 08:39:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH 06/12] wireless: Convert simple uses of a static const Ethernet broadcast address
References: <cover.1522479607.git.joe@perches.com>
        <79196f134a513d50968e8e208a0e56b3c0236ee3.1522479607.git.joe@perches.com>
Date: Thu, 05 Apr 2018 15:39:50 +0300
In-Reply-To: <79196f134a513d50968e8e208a0e56b3c0236ee3.1522479607.git.joe@perches.com>
        (Joe Perches's message of "Sat, 31 Mar 2018 00:05:21 -0700")
Message-ID: <87po3desix.fsf@kamboji.qca.qualcomm.com> (sfid-20180405_144015_561579_48853C09)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> Use the new ether_broadcast_addr global instead to save some object code.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/admtek/adm8211.c           | 3 +--
>  drivers/net/wireless/ath/carl9170/mac.c         | 4 +---
>  drivers/net/wireless/broadcom/b43/main.c        | 3 +--
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 3 +--
>  drivers/net/wireless/realtek/rtlwifi/core.c     | 5 ++---
>  drivers/net/wireless/rndis_wlan.c               | 6 +-----
>  drivers/net/wireless/ti/wl1251/main.c           | 5 +----
>  drivers/net/wireless/ti/wlcore/main.c           | 5 +----
>  8 files changed, 9 insertions(+), 25 deletions(-)

It would be really helpful if you could CLEARLY document in the patches
(or in the cover letter but then you need to cc all parties) to what
tree the patches are meant for. Otherwise I, and other maintainers as
well, need to waste time trying to guess what's your plan.

I will now drop the four wireless patches from my queue. So if you want
to me to take them please resubmit.

-- 
Kalle Valo
