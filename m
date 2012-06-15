Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2FOIQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 04:16:59 -0400
Message-ID: <1339748211.4512.6.camel@jlt3.sipsolutions.net> (sfid-20120615_101705_630572_A1DB8674)
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, me@bobcopeland.com,
	mickflemm@gmail.com
Date: Fri, 15 Jun 2012 10:16:51 +0200
In-Reply-To: <20120614193104.GD32257@tux>
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1339228530.4539.0.camel@jlt3.sipsolutions.net>
	 <4FD3A936.8070600@broadcom.com>
	 <1339399952.4520.13.camel@jlt3.sipsolutions.net>
	 <4FD60369.80108@qca.qualcomm.com>
	 <1339425944.4520.27.camel@jlt3.sipsolutions.net>
	 <20120614193104.GD32257@tux>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-14 at 12:31 -0700, Luis R. Rodriguez wrote:

> This option should really be used by OEM/ODM that have assured proper
> certification or scientists using a shielded room. Distros should be strongly
> adviced not to use this as their users tend to be unaware or the distribution
> ODM / OEM may not have done the necessary work to ensure proper regulatory
> certification. Perhaps we can clarify that there is a heavier onus on
> regulatory certification if these options are enabled. Linux distributions may
> be eager to please their users, but I would expect them to have common sense as
> well. We would just have to educate them about this option.

Yet nothing in the name of the option says so... You vaguely described
it in the Kconfig help text but that text feels like weaselling your way
out :-)

> As for a name, I thought about it for a while and given that we have different
> "wireless" technologies -- bluetooth, NFC, naming this CONFIG_WIRELESS_EXPERT
> seemed odd, and given that our 802.11 framework is under cfg80211 naming it
> CONFIG_CFG80211_EXPERT seemed appropriate. But even if its under cfg80211
> perhaps something more explicit about the implications may be better, how
> about CONFIG_CFG80211_MAY_BREAK_CERTIFICATION ?

Or you could just be explicit about it and call it
CONFIG_WIRELESS_REGULATORY_BREAKAGE or something like that :-)

johannes

