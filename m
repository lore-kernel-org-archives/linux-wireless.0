Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:45476 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081AbYAYNbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 08:31:50 -0500
Subject: Re: [PATCH 00/14] RFC: Driver for Wireless RNDIS USB devices.
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080124185321.GB3200@tuxdriver.com>
References: <20080120001342.25718.83669.stgit@fate.lan>
	 <1201094475.7733.1.camel@localhost> <20080123145243.GA3129@tuxdriver.com>
	 <1201110286.8696.10.camel@localhost>  <20080124185321.GB3200@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 15:25:40 +0200
Message-Id: <1201267540.7266.12.camel@localhost> (sfid-20080125_133154_560673_2ED0813D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-01-24 at 13:53 -0500, John W. Linville wrote:
> Overall this looks fine to me for initial merge.  I have a couple
> of comments:
> 
> 	-- I'm not too excited about the "Ndis_802_*" naming scheme for
> 	data structures, although I know you copied it from elsewhere.
> 	I'd like to see it changed, but I don't consider that a
> 	merge blocker.
To be honest I'm not either, but I'll prioritise this for later.

> 	-- I foresee this driver surviving a conversion to use the
> 	new cfg80211 configuraiton API.  So the "rndis_wext" name may
> 	not be the best long-term choice.  I might suggest something
> 	like "rndis_wlan".  I don't see why we couldn't change that
> 	post-merge, although I would prefer to do that before the
> 	final 2.6.25 release.
Sure.

> So, I intend to push this upstream for 2.6.25.  Please consider making
> the changes cited above, especially the name change.
Ok, I'll make new patchset with name change and changes David Brownell
wants on usbnet patches.

 - Jussi


