Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZBTXl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 18:41:58 -0500
Date: Fri, 20 Feb 2009 18:41:55 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com
Subject: Re: [PATCH v4 00/15] cfg80211: add a workqueue for regulatory
	processing
Message-ID: <20090220234155.GC23428@bombadil.infradead.org> (sfid-20090221_004216_701339_C1DF1BD6)
References: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com> <1235050171.4023.64.camel@johannes.local> <43e72e890902191640u107ff0fdse92367fccc975dba@mail.gmail.com> <1235149043.4023.66.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1235149043.4023.66.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 20, 2009 at 05:57:23PM +0100, Johannes Berg wrote:
> On Thu, 2009-02-19 at 16:40 -0800, Luis R. Rodriguez wrote:
> 
> > > I don't know why you insist on having a wrapper for
> > > wiphy->wiphy_idx but it's ok :)
> > 
> > Heh its just because wiphy->wiphy_idx does not exist, the drv has so
> > you must go to the container and then use that. If we move the idx to
> > the wiphy then I'm good to use wiphy->wiphy_idx. Want to do that?
> 
> Ah. Not sure, but I don't think we need to expose that to drivers.

Unless we may need it later for virtual wiphys, not sure, Jouni?

  Luis
