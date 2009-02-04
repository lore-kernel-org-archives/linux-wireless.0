Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45601 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933AbZBDTu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 14:50:59 -0500
Date: Wed, 4 Feb 2009 21:50:55 +0200
From: Jouni Malinen <j@w1.fi>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] Document CONFIG_DRIVER_NL80211 in
	wpa_supplicant/defconfig
Message-ID: <20090204195055.GB28563@jm.kir.nu> (sfid-20090204_205102_552838_638D585C)
References: <20090204062021.12891.96607.stgit@ct.roinet.com> <20090204062037.12891.4454.stgit@ct.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090204062037.12891.4454.stgit@ct.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 04, 2009 at 01:20:37AM -0500, Pavel Roskin wrote:
> Put it after CONFIG_DRIVER_WEXT, as it's the new Linux wireless API.
> Move comments about kernel includes next to CONFIG_DRIVER_NL80211, away
> from CONFIG_CLIENT_MLME.

Thanks. CONFIG_DRIVER_NL80211 part applied as-is; the WIRELESS_DEV
comment was removed since it does not apply anymore.
CONFIG_DRIVER_NL80211 was missing by design since the driver_nl80211.c
code was not yet complete. Anyway, it is now functional enough to be
included in wpa_supplicant defconfig. Though, I did leave it commented
out for the time being.

-- 
Jouni Malinen                                            PGP id EFC895FA
