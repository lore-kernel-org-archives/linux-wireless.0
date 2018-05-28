Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:41028 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753910AbeE1IUW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 04:20:22 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Eyal Reizer <eyalreizer@gmail.com>
CC: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH] wlcore: sdio: check for valid platform
   device data before suspend
Date: Mon, 28 May 2018 08:20:00 +0000
Message-ID: <825adbcb92cf4b6980a4029db7fdd863@ti.com> (sfid-20180528_102028_028579_5EE2DA9E)
References: <1527161730-9044-1-git-send-email-eyalr@ti.com>
 <20180524142440.GY77025@atomide.com>
In-Reply-To: <20180524142440.GY77025@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > the wl pointer can be null In case only wlcore_sdio is probed while
> > no WiLink module is successfully probed, as in the case of mounting a
> > wl12xx module while using a device tree file configured with wl18xx
> > related settings.
> > In this case the system was crashing in wl1271_suspend() as platform
> > device data is not set.
> > Make sure wl the pointer is valid before using it.
>=20
> Just checking.. It seems like this fix is separate from the PM
> runtime conversion, right?

Correct. This is a separate patch/
>=20
> > Signed-off-by: Eyal Reizer <eyalr@ti.com>mamai
>=20
> Looks like you have some extra characters ^^^^^ here.
>=20
Thanks!. Will fix and submit v2

Best Regards,
Eyal
