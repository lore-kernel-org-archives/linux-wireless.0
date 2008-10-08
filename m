Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:35684 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbYJHQTh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 12:19:37 -0400
Date: Wed, 8 Oct 2008 19:18:34 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rami Rosen <ramirose@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH ] mac80211: fix wrong link typo in mac80211_hwsim
	documentation.
Message-ID: <20081008161834.GL4941@jm.kir.nu> (sfid-20081008_181942_089178_735F0DDD)
References: <eb3ff54b0810080243r416b8413uf2e12f51c309a8b7@mail.gmail.com> <1223459201.3618.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223459201.3618.49.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2008 at 11:46:41AM +0200, Johannes Berg wrote:
> On Wed, 2008-10-08 at 11:43 +0200, Rami Rosen wrote:
> >  Please note that the current Linux kernel does not enable AP mode, so
> > a
> >  simple patch is needed to enable AP mode selection:
> > -http://johannes.sipsolutions.net/patches/kernel/all/LATEST/006-allow-ap-vlan-modes.patch
> > -
> > +http://johannes.sipsolutions.net/patches/kernel/all/LATEST/004-allow-ap-vlan-modes.patch
> 
> No good, the numbering changes all the time.

Well.. I see two possible fixes here: we'll finally apply that patch or
point to http://w1.fi/wireless-testing/enable-ap-mode.patch which does
not change its URL all the time.. I'm starting to lean more towards the
prior option, though, since I'm getting tired of pointing people to this
patch whenever they complain that hostapd does not work with mac80211.

-- 
Jouni Malinen                                            PGP id EFC895FA
