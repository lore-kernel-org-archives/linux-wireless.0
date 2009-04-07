Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60602 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760205AbZDGQIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 12:08:19 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 09:08:19 -0700
Date: Tue, 7 Apr 2009 09:08:13 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
Message-ID: <20090407160812.GA5758@tesla> (sfid-20090407_180823_733339_1442521F)
References: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com> <3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com> <3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com> <43e72e890904062234m3d572f36t1aa7fefa5f78ae74@mail.gmail.com> <3ace41890904070049tc2ed1baod4399a327505ef09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <3ace41890904070049tc2ed1baod4399a327505ef09@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 07, 2009 at 12:49:30AM -0700, Hin-Tak Leung wrote:
> On Tue, Apr 7, 2009 at 6:34 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> 
> > Not sure, I wanted to get this out to help those who are interested in
> > porting changes over (if any) to zd1211rw. If you find nothing useful
> > from it please simply disregard it.
> 
> It is vaguely relevant in that (1) there are new and old features
> which are not in the rw driver yet - e.g. the AP mode,  and
> 3.0 introduces newly antenna diversity, (2) to port changes - either
> new-hardware related, or bug-fixes/improvements, they need to be
> proven to work-better ... e.g. blindly copying could just copy
> mistakes/regressions...

Right, that is the idea.

  Luis
