Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:45265 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab0JDKpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 06:45:36 -0400
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o94AjZuW032192
	for <linux-wireless@vger.kernel.org>; Mon, 4 Oct 2010 13:45:35 +0300
Subject: Re: [PATCH 1/2] wl1271: Indicate disconnection on hardware failure
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285843408-6726-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1285843408-6726-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 13:45:11 +0300
Message-ID: <1286189111.27112.11.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 12:43 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> In the event of a hardware failure, reconfiguring a live connection back
> with the wl1271 chip does not work as expected. The chip has management
> features which require setting up the association from scratch to work
> correctly. To ensure this is done every time, in managed mode, when associated,
> indicate connection loss to the mac80211 before asking to reconfigure the
> hardware.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>

I'll apply this to wl12xx soon.


-- 
Cheers,
Luca.

