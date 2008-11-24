Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46671 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYKXVBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 16:01:14 -0500
Date: Mon, 24 Nov 2008 15:45:31 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rami Rosen <ramirose@gmail.com>, linux-wireless@vger.kernel.org,
	j@w1.fi
Subject: Re: [PATCH 1/2] mac80211: enabling an AP that can't support fully
	PS clients (wireless-testing).
Message-ID: <20081124204531.GC3983@tuxdriver.com> (sfid-20081124_220119_575325_EBBCFDB8)
References: <eb3ff54b0811232344m77f979aaj79e9e965eefa325c@mail.gmail.com> <1227522732.3599.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1227522732.3599.58.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 24, 2008 at 11:32:12AM +0100, Johannes Berg wrote:
> On Mon, 2008-11-24 at 09:44 +0200, Rami Rosen wrote:
> > This patch enables mac80211 to support the PS challenged mode when
> > used in master mode.
> > A new attribute, NL80211_ATTR_WIPHY_AP_PS_CHALLENGED, was added to
> > nl80211_attrs; also a new member (ap_ps_challenged) was added to
> > struct wiphy; and nl80211_send_wiphy() was adjusted accordingly.
> > 
> > User space applications (like hostapd) should check the
> > NL80211_ATTR_WIPHY_AP_PS_CHALLENGED
> > attribute and  display a proper message, if it is set, to inform the
> > users.
> 
> Jouni, thoughts about the naming? I proposed this to Rami but I'm not
> married to it, any better idea?

NL80211_ATTR_WIPHY_AP_PS_UNSUPPORTED?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
