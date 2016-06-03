Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40492 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbcFCOpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 10:45:17 -0400
Date: Fri, 3 Jun 2016 10:34:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Anyone have a clone of wireless-legacy.git?
Message-ID: <20160603143408.GL6230@tuxdriver.com> (sfid-20160603_164540_653040_1C8C02CD)
References: <20160602183803.GH6230@tuxdriver.com>
 <20160603011827.GA2542@roeck-us.net>
 <1464937583.2224.0.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1464937583.2224.0.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 03, 2016 at 09:06:23AM +0200, Johannes Berg wrote:
> 
> > http://www.filewatcher.com/_/?q=wireless-legacy.git, maybe ?
> > 
> 
> Seems to work - both have the same branches:
> 
>   adm8211                 72c942ed694e [PATCH] adm8211: fix build breakage from skb->mac.raw
>   at76                    279f8592e428 cfg80211: keep track of supported interface modes (at76)
>   ath5k                   8584ac94e3bb [PATCH] ath5k: Internalize Atheros Turbo modes
>   ath5k-2008-01-21        5b8ca29e11b5 ath5k: remove duplicate bssid variable
>   mac80211-attic          2bc68d999610 [PATCH] mac80211: remove scan struct from hostapd_param
>   mac80211-dungeon        ad097a32e9ad [PATCH] mac80211 [HT] 802.11 code compiles under CONFIG_MAC80211_HT
>   prism54usb              101e59f5e18a prism54usb: more fix for wireless Kconfig changes
>   rtl8180-2008-01-21      55fc0e806a93 rtl8180: remove calibration error message for rtl8225z2
>   tiacx                   d6a6811c508b [PATCH] TI acx100/acx111: Make debug level selectable in configuration
>   wireless-dev-2007-08-10 ca29ec8f05c1 Merge ../wireless-dev-legacy into wireless-dev-2007-08-10
>   wireless-dev-2007-09-24 cd799e167394 Merge branch 'p54' into everything
> 
> johannes

I got them both from the two FTP sites, and both git repos appear to
be identical.  It would be best if someone had an actual record of
the commit hash values, but this might be the best I/we can do...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
