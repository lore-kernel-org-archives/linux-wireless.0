Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51638 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946152Ab3BHJWF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 04:22:05 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id r189M4S4016640
	for <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 03:22:04 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r189M4CD031257
	for <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 03:22:04 -0600
Message-ID: <1360315266.12803.29.camel@cumari.coelho.fi> (sfid-20130208_102624_390758_75B86AE4)
Subject: Re: [PATCH] wl18xx: add new phy configuration parameters for telec
 support
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <victorg@ti.com>
Date: Fri, 8 Feb 2013 11:21:06 +0200
In-Reply-To: <1360311553-2543-1-git-send-email-coelho@ti.com>
References: <1360311553-2543-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 10:19 +0200, Luciano Coelho wrote:
> From: Victor Goldenshtein <victorg@ti.com>
> 
> Add back-off settings to the wl18xx_mac_and_phy_params.  We had an
> empty space where the new parameters are added, so this change doesn't
> affect backwards-compatibility with older firmwares.
> 
> Update WL18XX_CONF_VERSION accordingly.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

--
Luca.

