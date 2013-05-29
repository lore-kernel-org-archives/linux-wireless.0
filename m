Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44702 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965989Ab3E2TAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 15:00:08 -0400
Date: Wed, 29 May 2013 14:52:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-05-27
Message-ID: <20130529185229.GE8770@tuxdriver.com> (sfid-20130529_210028_221826_6A745850)
References: <1369658569.14740.11.camel@jlt4.sipsolutions.net>
 <1369660310.14740.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1369660310.14740.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 27, 2013 at 03:11:50PM +0200, Johannes Berg wrote:
> On Mon, 2013-05-27 at 14:42 +0200, Johannes Berg wrote:
> > John,
> > 
> > I also have a bunch of new things for cfg80211/mac80211. Just like with
> > iwlwifi, I had to merge my mac80211 tree, so this pulled in some more
> > changes that looks spurious. Again, a better looking shortlog all the
> > way at the end.
> > 
> > The biggest change this time is my cfg80211 locking and MLME/SME work,
> > cleaning up locking there by greatly reducing the number of different
> > useless locks. Other than that, some relatively minor things.
> > 
> > Please let me know of any problems.
> > 
> > johannes
> > 
> > 
> > The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:
> > 
> >   Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> > 
> > for you to fetch changes up to 0dd83174762ff46356824217e69daf374f794ba4:
> 
> Oh, there was a build error here, I've corrected it and the new HEAD is
> now 6abb9cb99f33b20c2f32f18a3ae9cc7543e46edb.

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
