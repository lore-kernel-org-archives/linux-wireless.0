Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34122 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbZBDU7S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 15:59:18 -0500
Subject: Re: [PATCH 2/2] Document CONFIG_DRIVER_NL80211 in
 wpa_supplicant/defconfig
From: Pavel Roskin <proski@gnu.org>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090204195055.GB28563@jm.kir.nu>
References: <20090204062021.12891.96607.stgit@ct.roinet.com>
	 <20090204062037.12891.4454.stgit@ct.roinet.com>
	 <20090204195055.GB28563@jm.kir.nu>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 15:59:12 -0500
Message-Id: <1233781152.7796.14.camel@dv> (sfid-20090204_215922_464050_CFD91D19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-02-04 at 21:50 +0200, Jouni Malinen wrote:
> On Wed, Feb 04, 2009 at 01:20:37AM -0500, Pavel Roskin wrote:
> > Put it after CONFIG_DRIVER_WEXT, as it's the new Linux wireless API.
> > Move comments about kernel includes next to CONFIG_DRIVER_NL80211, away
> > from CONFIG_CLIENT_MLME.
> 
> Thanks. CONFIG_DRIVER_NL80211 part applied as-is; the WIRELESS_DEV
> comment was removed since it does not apply anymore.
> CONFIG_DRIVER_NL80211 was missing by design since the driver_nl80211.c
> code was not yet complete. Anyway, it is now functional enough to be
> included in wpa_supplicant defconfig. Though, I did leave it commented
> out for the time being.

Looks good to me.  Thank you!

-- 
Regards,
Pavel Roskin
