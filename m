Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50926 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbZFIHdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 03:33:05 -0400
Date: Tue, 9 Jun 2009 00:01:05 -0700
From: Greg KH <gregkh@suse.de>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] Staging: stlc45xx: sync with gitorious git tree
Message-ID: <20090609070105.GA25780@suse.de>
References: <20090608190901.25081.26264.stgit@tikku> <20090609004532.GA22830@suse.de> <87prde2ft8.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87prde2ft8.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 09, 2009 at 07:26:27AM +0300, Kalle Valo wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Mon, Jun 08, 2009 at 10:09:01PM +0300, Kalle Valo wrote:
> >> From: Kalle Valo <kalle.valo@nokia.com>
> >> 
> >> Sync up with stlc45xx repository in gitorious.org from commit
> >> bb8675d6e59c34b43618970d37d56d724a5e3d96.
> >
> > Hm, any reason you smushed 23 patches down into 3?  In doing so you lost
> > some good information, and some authorship information as well, which is
> > not acceptable.
> 
> I did shortcuts to avoid the merge hassle. I had some branch trickery
> with the gitorious stlc45xx repository which will most probably take
> some time to solve.
> 
> > So care to send me the 23 patches instead, with the proper authorship
> > information?
> 
> Sure I can. It might take some time, though.

Ok, I'm in no rush :)

> Please note that slc45xx won't compile in linux-next due to mac80211 API
> changes until these patches have been applied.

Understood.

> > And why is development for this driver being done outside the kernel
> > tree now that is in it?
> 
> These changes have been implemented before stlc45xx was accepted to the
> staging tree. They have been just pending on my side.

Ah, ok.

thanks,

greg k-h
