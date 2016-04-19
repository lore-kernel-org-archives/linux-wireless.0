Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48885 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbcDSI55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 04:57:57 -0400
Message-ID: <1461056272.2766.8.camel@sipsolutions.net> (sfid-20160419_105913_049024_080BAEBF)
Subject: Re: [PATCH v3] prism54: isl_38xx: Replace 'struct timeval'
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>,
	y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 Apr 2016 10:57:52 +0200
In-Reply-To: <4679823.7bDEQhE9qO@wuerfel>
References: <20160413060916.GA21184@localhost> <5521267.mr5HLCdTY6@wuerfel>
	 <1460896953.15362.2.camel@sipsolutions.net> <4679823.7bDEQhE9qO@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-04-18 at 00:10 +0200, Arnd Bergmann wrote:
> On Sunday 17 April 2016 14:42:33 Johannes Berg wrote:
> > 
> > 
> > I was thinking more restrictively of just the stuff that can't even
> > be
> > built without modifying the sources - like the "#if VERBOSE" thing.
> All the DEBUG() statements are inside of this kind of check, so if we
> remove the #ifdefs, it would be logical to remove the rest of the
> debugging infrastructure (DEBUG() macros, SHOW_*, pc_debug, maybe
> more) as well.
> 

Seems reasonable.

Maybe we should Cc the maintainer, but I suspect that since the driver
is marked Obsolete anyway Luis won't care either :)

johannes
