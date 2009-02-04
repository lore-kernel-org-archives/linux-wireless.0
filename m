Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52324 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410AbZBDTqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 14:46:06 -0500
Date: Wed, 4 Feb 2009 21:45:57 +0200
From: Jouni Malinen <j@w1.fi>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] Use better examples for MadWifi path in defconfig,
	clarify comments
Message-ID: <20090204194557.GA28563@jm.kir.nu> (sfid-20090204_204610_909387_4EE2111A)
References: <20090204062021.12891.96607.stgit@ct.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090204062021.12891.96607.stgit@ct.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 04, 2009 at 01:20:21AM -0500, Pavel Roskin wrote:
> MadWifi is unlikely to be in ../head relative to hostapd or
> wpa_supplicant, as it would be inside the hostap git repository.
> MadWifi sources are more likely to be in a directory called "madwifi"
> and residing outside the hostap repository.  Using "madwifi" also
> demonstrates that the top-level madwifi directory is needed.

>  hostapd/defconfig        |    2 +-
>  wpa_supplicant/defconfig |    4 ++--

Thanks, applied.

-- 
Jouni Malinen                                            PGP id EFC895FA
