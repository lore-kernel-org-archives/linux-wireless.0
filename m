Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab2HZHo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 03:44:59 -0400
Message-ID: <1345967092.3622.2.camel@jlt4.sipsolutions.net> (sfid-20120826_094502_906151_595EAE6B)
Subject: Re: [PATCH v1] cfg80211: Support for 4-way handshake offloading for
 WPA2-Personal
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Sun, 26 Aug 2012 09:44:52 +0200
In-Reply-To: <3373913.UaOl7A5Fl4@lx-vladimir>
References: <1343907187-6686-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1850661.W9RYC5ddVW@lx-vladimir>
	 <1345737566.4534.12.camel@jlt3.sipsolutions.net>
	 <3373913.UaOl7A5Fl4@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-08-26 at 10:11 +0300, Vladimir Kondratiev wrote:

> > >       if ((dev->wiphy.flags & WIPHY_FLAG_IBSS_RSN) &&
> > >           nla_put_flag(msg, NL80211_ATTR_SUPPORT_IBSS_RSN))
> > >               goto nla_put_failure;
> > 
> > Yes, but we abandoned this approach later, in favour of the nl80211
> > feature flags.
> 
> Good. Will re-implement this way.
> Could you please show an example that I can follow?

well, look at the feature flags.

enum nl80211_feature_flags

johannes

