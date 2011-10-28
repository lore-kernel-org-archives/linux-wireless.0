Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab1J1HeD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 03:34:03 -0400
Subject: Re: [RFC v2 13/12] cfg80211/mac80211: allow management TX to not
 wait for ACK
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAGXE3d8QJqPR5Q95ZVt+JzWRZAH5f=Nap1DT=mTmmajsAMYcWw@mail.gmail.com> (sfid-20111028_080945_056423_F7F002EB)
References: <20111021142322.229128720@sipsolutions.net>
	 <1319743973.32221.4.camel@jlt3.sipsolutions.net>
	 <CAGXE3d8QJqPR5Q95ZVt+JzWRZAH5f=Nap1DT=mTmmajsAMYcWw@mail.gmail.com>
	 (sfid-20111028_080945_056423_F7F002EB)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 09:34:00 +0200
Message-ID: <1319787240.3914.1.camel@jlt3.sipsolutions.net> (sfid-20111028_093407_986455_D5C503BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 08:09 +0200, Helmut Schaa wrote:
> On Thu, Oct 27, 2011 at 9:32 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > For probe responses it can be useful to not wait for ACK
> > to save airtime, so allow userspace to request not waiting
> > with a new nl80211 flag.
> >
> > Since mac80211 needs to be updated for the new function
> > prototype anyway implement it right away -- it's just a
> > few lines of code.
> 
> Ah, nice!
> 
> I'll adjust my hostad patch to make use of this instead of the
> radiotap flag (or maybe both, need to look into this further).

If you just do the radiotap part I'll add the rest with my other
patchset.

johannes

