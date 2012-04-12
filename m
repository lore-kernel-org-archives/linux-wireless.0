Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54743 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab2DLNHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 09:07:54 -0400
Message-ID: <1334236037.3451.0.camel@jlt3.sipsolutions.net> (sfid-20120412_150802_386836_50D9365A)
Subject: Re: [PATCH] compat: backport netif_wake_subqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lf_driver_backport@lists.linux-foundation.org
Date: Thu, 12 Apr 2012 15:07:17 +0200
In-Reply-To: <CAB=NE6UJS=dnUO0Cq-7Kve+7ofnbW-XkGHqCQCf+HzEMTRn8WQ@mail.gmail.com> (sfid-20120412_095637_585399_3C14FD57)
References: <1333746034.5577.10.camel@jlt3.sipsolutions.net>
	 <CAB=NE6XMuaAPFPfKGunrGuqnYLKfem35Q3nXiEpc7u23FM14ng@mail.gmail.com>
	 <1334204193.3788.14.camel@jlt3.sipsolutions.net>
	 <CAB=NE6UJS=dnUO0Cq-7Kve+7ofnbW-XkGHqCQCf+HzEMTRn8WQ@mail.gmail.com>
	 (sfid-20120412_095637_585399_3C14FD57)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-12 at 00:55 -0700, Luis R. Rodriguez wrote:
> On Wed, Apr 11, 2012 at 9:16 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2012-04-06 at 19:23 -0700, Luis R. Rodriguez wrote:
> >> On Fri, Apr 6, 2012 at 2:00 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >> > From: Johannes Berg <johannes.berg@intel.com>
> >> >
> >> > Kernels 2.6.23 - 2.6.27 had some multiqueue support,
> >> > but called netif_wake_subqueue netif_start_subqueue.
> >> > So to backport, just add a define.
> >> >
> >> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> >>
> >> Applied and pushed, and tested with ckmake, thanks!
> >
> > I don't see this, did you move the repository off infradead?
> 
> Sorry, I forgot to push to infra, the most reliable tree is on github.
> I use infra as backup.

Oh ok, I'll switch to github. Thanks.

johannes

