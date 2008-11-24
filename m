Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:37609 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYKXVF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 16:05:28 -0500
Date: Mon, 24 Nov 2008 23:05:10 +0200
From: Jouni Malinen <j@w1.fi>
To: Pavel Roskin <proski@gnu.org>
Cc: Rami Rosen <ramirose@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] mac80211: enabling an AP that can't support fully
	PS clients (wireless-testing).
Message-ID: <20081124210510.GA12881@jm.kir.nu> (sfid-20081124_220533_526345_BA7EDC23)
References: <eb3ff54b0811232344m77f979aaj79e9e965eefa325c@mail.gmail.com> <1227558612.28878.1.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1227558612.28878.1.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 24, 2008 at 03:30:12PM -0500, Pavel Roskin wrote:

> Maybe it would be better to require a switch to hostapd to enable
> support for such devices?  Messages are too easy to ignore.

Well, it would be more obvious to the user, but based on the comments on
this thread, I'm not that sure that this new flag is really needed at
this point. If the goal is to implement proper PS support in the driver,
there should not be need for this type of flag. Only if it is clear that
this won't work (i.e., hardware/firmware design issue that cannot be
fixed), should this type of flag be considered.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
