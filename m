Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:50109 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab0KVNXA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 08:23:00 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAMDMxbX032221
	for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 15:22:59 +0200
Subject: Re: [PATCHv3] wl12xx: Unset bssid filter, ssid and bssid from
 firmware on disassoc
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "ext juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1290423548-29861-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1290423548-29861-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 15:22:36 +0200
Message-ID: <1290432156.3322.20.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-22 at 12:59 +0200, ext juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> On the disassociation event from the mac80211, the wl12xx driver does not
> clear the chipset configuration related to the AP - i.e. it does not perform
> a DISCONNECT and then a JOIN with zero SSID and dummy BSSID. Also, it does not
> unset the BSSID filter.
> 
> Often this is not a problem, as the above is performed upon entering idle
> state. But if a scenario arises where a new association is attempted without
> cycling through idle state, the new association will fail.
> 
> Fix this by resetting the firmware state on disassociation.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>

This looks good now.  Applied.

-- 
Cheers,
Luca.

