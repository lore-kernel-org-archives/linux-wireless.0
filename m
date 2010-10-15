Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:35009 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0JOFnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 01:43:03 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9F5gwKd021585
	for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 08:42:59 +0300
Subject: Re: [PATCH v2] wl1271: Fix warning about unsupported RX rate
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287046804-19356-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1287046804-19356-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 08:42:51 +0300
Message-ID: <1287121371.2607.3.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-14 at 11:00 +0200, ext Teemu Paasikivi wrote:
> While scanning, it is possible that beacon and probe response frames are
> received on other band than configured to the driver. In rx status
> handling this has caused "Unsupported RX rate from HW" warnings. This
> patch changes the wl1271_rate_to_index function to take the band of the
> received frame as a parameter instead of using value configuret to
> wl->band.
> 
> Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> ---
> Changes v1 -> v2: Fixed patch to apply on wl12xx tree
> 
>  drivers/net/wireless/wl12xx/wl1271_main.c |    6 +++---
>  drivers/net/wireless/wl12xx/wl1271_rx.c   |   10 +++++++++-
>  drivers/net/wireless/wl12xx/wl1271_rx.h   |    2 +-
>  drivers/net/wireless/wl12xx/wl1271_tx.c   |    2 +-
>  drivers/net/wireless/wl12xx/wl1271_tx.h   |    2 +-
>  5 files changed, 15 insertions(+), 7 deletions(-)
> 

Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

-Juuso


