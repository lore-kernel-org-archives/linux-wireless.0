Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1HLJb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 05:31:26 -0400
Subject: Re: [PATCH 8/8] {nl,cfg,mac}80211: let userspace make meshif mesh
 gate
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
In-Reply-To: <CAG6hwVNFUyt7VBEiaNpCoGFmt4eMbvexKA0pUtGi3sj3mwHgZQ@mail.gmail.com> (sfid-20110810_233148_216249_1066196B)
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	 <1312933511-9486-9-git-send-email-thomas@cozybit.com>
	 <1312984078.4325.5.camel@jlt3.sipsolutions.net>
	 <CAG6hwVNFUyt7VBEiaNpCoGFmt4eMbvexKA0pUtGi3sj3mwHgZQ@mail.gmail.com>
	 (sfid-20110810_233148_216249_1066196B)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 11:31:21 +0200
Message-ID: <1313141481.4022.1.camel@jlt3.sipsolutions.net> (sfid-20110812_113130_515225_0BD5ACDA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-10 at 14:31 -0700, Thomas Pedersen wrote:
> On Wed, Aug 10, 2011 at 6:47 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2011-08-09 at 16:45 -0700, Thomas Pedersen wrote:
> >> From: Javier Cardona <javier@cozybit.com>
> >>
> >> Allow userspace to set NL80211_MESHCONF_GATE_ANNOUNCEMENTS attribute,
> >> which will advertise this mesh node as being a mesh gate.
> >> NL80211_HWMP_ROOTMODE must be set or this will do nothing.
> >
> > IMHO it should be rejected instead of doing nothing.
> >
> Maybe the "right thing" to do is not require the user to know anything
> about the limitations of our implementation, and instead just enable
> root mode as needed?

I don't know? Is it a limitation of the implementation? I know
practically nothing about mesh :-) It just didn't seem right to silently
ignore something.

johannes

