Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761801AbYFXOq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 10:46:27 -0400
Subject: Re: [PATCH] mac80211: add pre- and post-scan hooks
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1214306511.8967.288.camel@johannes.berg>
References: <1214149401.8585.2.camel@localhost.localdomain>
	 <1214297745.8967.255.camel@johannes.berg>
	 <1214306147.12270.9.camel@localhost.localdomain>
	 <1214306511.8967.288.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 10:45:09 -0400
Message-Id: <1214318709.18521.6.camel@localhost.localdomain> (sfid-20080624_164631_709260_A6FC2379)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-24 at 13:21 +0200, Johannes Berg wrote:
> On Tue, 2008-06-24 at 07:15 -0400, Dan Williams wrote:
> > On Tue, 2008-06-24 at 10:55 +0200, Johannes Berg wrote:
> > > On Sun, 2008-06-22 at 11:43 -0400, Dan Williams wrote:
> > > > mrv8k has commands that get called before and after the scan has been
> > > > done to save and restore hardware state.  Add optional callbacks to
> > > > mac80211 to enable low-level drivers to know when the stack is about to
> > > > start scanning, and when it's done.
> > > 
> > > I'm not entirely against this, but does it mean the driver will not work
> > > with the userspace MLME that does scanning itself in userspace too?
> > 
> > Probably not?  Both TopDog (linville's marvell.git and your
> > marvell.tar.bz2) both do this.  It's too early to tell whether we can
> > get along without it since the driver isn't functional enough yet.
> 
> Hm. Could we leave it out of mac80211 for now then until you know?

Fair enough.

> > BTW, where'd you get marvell.tar.bz2 from?
> 
> No idea, I don't remember, I could probably dig it up in my email but
> didn't find it quickly right now.

If it's not too much trouble, would be nice to know.

Thanks!
Dan

