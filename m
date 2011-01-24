Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41208 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1AXVKW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 16:10:22 -0500
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0OLAMwN021540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 15:10:22 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0OLAMTl011295
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 15:10:22 -0600 (CST)
Subject: Re: [PATCH v3  0/2] wl12xx: BA Initiator & receiver support
From: Luciano Coelho <coelho@ti.com>
To: "Levi, Shahar" <shahar_levi@ti.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295764043-29918-1-git-send-email-shahar_levi@ti.com>
References: <1295764043-29918-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 23:05:20 +0200
Message-ID: <1295903120.4430.1.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-23 at 07:27 +0100, Levi, Shahar wrote:
> That series gather two patches:
> [PATCH v7] wl12xx: BA initiator support
> [PATCH v5] wl12xx: BA receiver support
> 
> Add 80211n BA initiator & receiver session support wl1271 driver.
> BA initiator session management included in FW independently.
> Include supported FW version auto detection mechanism.
> 
> Limitation:
> - For now only one BA per direction is supported
> 
> Shahar Levi (2):
>   wl12xx: BA initiator support
>   wl12xx: BA receiver support
> 
>  drivers/net/wireless/wl12xx/acx.c    |   85 ++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/wl12xx/acx.h    |   62 ++++++++++++++++++++++++-
>  drivers/net/wireless/wl12xx/boot.c   |   24 ++++++++-
>  drivers/net/wireless/wl12xx/conf.h   |    6 ++
>  drivers/net/wireless/wl12xx/init.c   |   41 ++++++++++++++++
>  drivers/net/wireless/wl12xx/main.c   |   72 +++++++++++++++++++++++++++--
>  drivers/net/wireless/wl12xx/wl12xx.h |   16 ++++++-
>  7 files changed, 296 insertions(+), 10 deletions(-)

Applied, thanks!


-- 
Cheers,
Luca.

