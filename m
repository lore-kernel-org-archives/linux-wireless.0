Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:47475 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbYHMGvA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 02:51:00 -0400
Date: Wed, 13 Aug 2008 09:50:08 +0300
From: Jouni Malinen <j@w1.fi>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Helmut Schaa <hschaa@suse.de>, linux-wireless@vger.kernel.org
Subject: Re: Pondering: how to improve mac80211 roaming ...
Message-ID: <20080813065008.GG4981@jm.kir.nu> (sfid-20080813_085103_101427_33633C83)
References: <200808120838.52888.hs4233@mail.mn-solutions.de> <20080812154223.GE4981@jm.kir.nu> <43e72e890808121056ua211e66lbc7bc8d619390bfd@mail.gmail.com> <200808130841.37180.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200808130841.37180.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 13, 2008 at 08:41:37AM +0200, Holger Schurig wrote:

> Nice tip. From this page, I saw that wpa_supplicant supports 
> 802.11r (Fast BSS transition: establish security/QoS to an AP 
> before making the transition). I assume that mac80211 doesn't 
> support this yet?

Yes, that would be the case for client mode with MLME in mac80211. I
would expect AP mode to be working with mac80211 + hostapd since MLME is
in hostapd in that case. I'm first hoping to get mac80211 +
wpa_supplicant with user space MLME working with 802.11r. It should be
possible to make this work with mac80211-based client MLME, too, if
desired.

-- 
Jouni Malinen                                            PGP id EFC895FA
