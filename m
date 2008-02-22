Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3498 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbYBVQCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 11:02:35 -0500
Date: Fri, 22 Feb 2008 10:59:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH 00/13 v2] o11s: mesh interface support for mac80211
Message-ID: <20080222155951.GE3067@tuxdriver.com> (sfid-20080222_160353_953024_DF923786)
References: <47be76f9.03b48c0a.025f.54f4@mx.google.com> <1203693709.7082.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203693709.7082.35.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 22, 2008 at 04:21:49PM +0100, Johannes Berg wrote:

> > The patches are to be applied on top of wireless-2.6/everything HEAD. Even
> > though I am sure there will be some issues, it would be great if we could
> > integrate this as soon as possible to make it easier for other people to
> > collaborate and to make my life a bit easier :-)
> 
> Hm. I think you'd have to rebase on top of wireless-testing/master but
> I'm not sure how they currently differ. See John Linville's mail on the
> new tree structure.

They were euivalent until day before yesterday.  No
wireless-2.6/everything is gone and wireless-testing/master has
progressed.  Please use wireless-testing/master for any future patches.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
