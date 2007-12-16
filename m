Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3179 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbXLPC63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 21:58:29 -0500
Date: Sat, 15 Dec 2007 21:24:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP][PATCH] rc80211_pid: Send events to userspace for
	debugging
Message-ID: <20071216022402.GD3096@tuxdriver.com> (sfid-20071216_025906_493994_B82C1A38)
References: <1197414686.7030.27.camel@localhost> <20071214231452.21ece93d@morte> <20071215175656.GB3096@tuxdriver.com> <1197756838.7540.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197756838.7540.12.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 15, 2007 at 11:13:58PM +0100, Mattias Nissler wrote:
> 
> On Sat, 2007-12-15 at 12:56 -0500, John W. Linville wrote:
> > On Fri, Dec 14, 2007 at 11:14:52PM +0100, Stefano Brivio wrote:
> > > Here comes an amended patch which works with my tree and should be more
> > > mergeable (as it splits the debugfs stuff to another file) just for
> > > convenience and to save Mattias some hassle. Hope this helps.
> > 
> > Speaking of mergeable, we need some "final" patches RSN if we want
> > to have this available in 2.6.25.  So, are we satisified with it?
> 
> I'm still tuning, testing, etc. I hope we can get a polished patch set
> ready by the end of Sunday.

If it mostly works and the code is reasonable, then let's get it
merged.  We have plenty of time for final tuning patches, but if the
rc80211_pid code isn't in before the merge window then it will have
to wait another whole release cycle.

John
-- 
John W. Linville
linville@tuxdriver.com
