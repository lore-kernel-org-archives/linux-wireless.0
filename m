Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4679 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934475AbXHIOgs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2007 10:36:48 -0400
Date: Thu, 9 Aug 2007 10:23:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif  config
Message-ID: <20070809142325.GD7811@tuxdriver.com>
References: <200708071744.40287.mb@bu3sch.de> <20070808164327.45803a64.akpm@linux-foundation.org> <20070809135326.GB7811@tuxdriver.com> <200708091608.43994.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200708091608.43994.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 09, 2007 at 04:08:43PM +0200, Michael Buesch wrote:
> On Thursday 09 August 2007 15:53:26 John W. Linville wrote:
> > On Wed, Aug 08, 2007 at 04:43:27PM -0700, Andrew Morton wrote:
> > 
> > > I'm hopelessly confused by the ssb stuff.  I'm not sure if I have all the
> > > right stuff, all the latest stuff and I don't understand why some is going
> > > into git-wireless and some is not.
> > 
> > Once you added ssb patches to -mm, I dropped the ssb stuff from the
> > mm-master branch of wireless-dev in hopes of avoiding conflicts.
> > 
> > Ugh, it looks like some new stuff has leaked-through -- I'll get rid
> > of it.
> 
> I think we decided that it was not a good idea to maintain ssb in
> the -mm tree, so I think we'll have to maintain it in a seperate
> branch of wireless-dev. Any idea?

Responded later in the thread -- you've probably seen them by the
time you get this... :-)

John
-- 
John W. Linville
linville@tuxdriver.com
