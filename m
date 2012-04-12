Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52438 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2DLERL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 00:17:11 -0400
Message-ID: <1334204193.3788.14.camel@jlt3.sipsolutions.net> (sfid-20120412_061736_563769_FFA34027)
Subject: Re: [PATCH] compat: backport netif_wake_subqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lf_driver_backport@lists.linux-foundation.org
Date: Thu, 12 Apr 2012 06:16:33 +0200
In-Reply-To: <CAB=NE6XMuaAPFPfKGunrGuqnYLKfem35Q3nXiEpc7u23FM14ng@mail.gmail.com> (sfid-20120407_042425_741610_83C8F3EA)
References: <1333746034.5577.10.camel@jlt3.sipsolutions.net>
	 <CAB=NE6XMuaAPFPfKGunrGuqnYLKfem35Q3nXiEpc7u23FM14ng@mail.gmail.com>
	 (sfid-20120407_042425_741610_83C8F3EA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-04-06 at 19:23 -0700, Luis R. Rodriguez wrote:
> On Fri, Apr 6, 2012 at 2:00 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Kernels 2.6.23 - 2.6.27 had some multiqueue support,
> > but called netif_wake_subqueue netif_start_subqueue.
> > So to backport, just add a define.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Applied and pushed, and tested with ckmake, thanks!

I don't see this, did you move the repository off infradead?

johannes

