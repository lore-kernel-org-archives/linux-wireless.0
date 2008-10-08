Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:40206 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbYJHTi5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 15:38:57 -0400
Date: Wed, 8 Oct 2008 22:37:54 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Rami Rosen <ramirose@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH ] mac80211: fix wrong link typo in mac80211_hwsim
	documentation.
Message-ID: <20081008193754.GM4941@jm.kir.nu> (sfid-20081008_213859_557165_1491A3D5)
References: <eb3ff54b0810080243r416b8413uf2e12f51c309a8b7@mail.gmail.com> <1223459201.3618.49.camel@johannes.berg> <20081008161834.GL4941@jm.kir.nu> <20081008190109.GC32472@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081008190109.GC32472@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2008 at 03:01:09PM -0400, John W. Linville wrote:

> Well I might be OK with that -- but are you (and Johannes) ready
> to deal with the various "ap mode doesn't work with my hostapd
> configuration" problems?

I think that that is a better and more productive problem to handle
assuming the issues are indeed because of something missing from
cfg80211 configuration. I'm supposed to make sure that everything needed
is there anyway and getting additional people testing various
combinations and reporting potential problems sounds useful.

-- 
Jouni Malinen                                            PGP id EFC895FA
