Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:51374 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab0JZMpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 08:45:50 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9QCjmP8010740
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 15:45:49 +0300
Subject: Re: [PATCH 2/2] wl1271: Check interface state in op_* functions
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288092279-31272-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1288092279-31272-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1288092279-31272-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 15:45:27 +0300
Message-ID: <1288097127.27698.4.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-26 at 13:24 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Check the state of the interface on op_* function so we don't try to access
> the hardware in when its off.
> 
> The mac80211 may call these in some corner cases related, for instance, to
> the hardware recovery procedure. These accesses cause a kernel crash on at
> least some SDIO devices, because the bus is not properly claimed in that
> scenario.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>

Thanks! applied to wl12xx.

-- 
Cheers,
Luca.

