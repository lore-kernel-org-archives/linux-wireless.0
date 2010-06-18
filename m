Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31520 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761286Ab0FRQdz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 12:33:55 -0400
Subject: Re: [PATCH 1/2] ath9k_htc: Add AP mode to supported modes
From: Pavel Roskin <proski@gnu.org>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <19481.60102.659111.953695@gargle.gargle.HOWL>
References: <19481.60102.659111.953695@gargle.gargle.HOWL>
Content-Type: text/plain
Date: Fri, 18 Jun 2010 12:33:51 -0400
Message-Id: <1276878831.5110.4.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-17 at 14:58 +0530, Sujith wrote:
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 ++-
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 +++
>  2 files changed, 5 insertions(+), 1 deletions(-)

I confirm that the AP mode is working on TP-Link TL-WN422G (0cf3:1006).
I tested both patched of the series at once.

That's great news!  TL-WN422G has an external antenna, connects over USB
and supports AP mode.  Users keep asking about that combination of
features.  Now we have an answer :-)

-- 
Regards,
Pavel Roskin
