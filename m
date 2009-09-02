Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34882 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbZIBVqA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 17:46:00 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 14:46:03 -0700
Date: Wed, 2 Sep 2009 14:46:01 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Werner Almesberger <werner@openmoko.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<Len.Widra@atheros.com>, <linux-wireless@vger.kernel.org>
Subject: Re: ar6k driver
Message-ID: <20090902214601.GB5614@mosca>
References: <20090901170030.GE8261@mosca>
 <20090902071849.GM4363@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090902071849.GM4363@almesberger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 02, 2009 at 12:18:49AM -0700, Werner Almesberger wrote:
> Luis R. Rodriguez wrote:
> > I know I found it last time I looked through the openmoko wiki but
> > it took me a lot of time to actually find the git tree and then
> > the branch name. Today I gave up looking for it so resorting to
> > asking you for the git url.
> 
> Yeah, it can be a little hard to find, particularly the right branch :-)
> 
> The repository is here:
> git://git.openmoko.org/git/openmoko.git
> 
> The branch with the latest code is origin/andy-tracking
> 
> Finally, my HIF is here:
> drivers/ar6000/hif/hif2.c

Thanks, I've created a new page for ar6k on the wireless.kernel.org wiki so
we don't loose track of this and so that this can be easier to find for others.

http://wireless.kernel.org/en/users/Drivers/ar6k

I've updated the openmoko wiki respectively:

http://wiki.openmoko.org/wiki/AR6K

  Luis
