Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab2LGLky (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 06:40:54 -0500
Date: Fri, 7 Dec 2012 12:40:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless:  Fix ethtool stats and other ops.
Message-ID: <20121207114045.GC11933@redhat.com> (sfid-20121207_124058_468002_716543F0)
References: <1354729192-22945-1-git-send-email-greearb@candelatech.com>
 <87a9ts4c1q.fsf@nemi.mork.no>
 <50BF8C18.9060504@candelatech.com>
 <20121206122528.GG2502@redhat.com>
 <50C0FCE0.2090507@candelatech.com>
 <20121207095012.GB11933@redhat.com>
 <87zk1q3xrv.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <87zk1q3xrv.fsf@nemi.mork.no>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 07, 2012 at 12:30:12PM +0100, Bjørn Mork wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> > On Thu, Dec 06, 2012 at 12:15:28PM -0800, Ben Greear wrote:
> >> I don't have time to work on this today...maybe not tomorrow either.
> >> 
> >> So, if someone else feels like fixing it, please feel free.
> >
> > Ok, I'll try to fix that. However this could require modification
> > of all cfg80211 drivers, so could not be fast.
> 
> I wonder if that strategy isn't just adding unnecessary complexity?  How
> about using something like the (completely untested) patch below instead?

Yeah, I wrote very similar patch and I'm testing it locally. Plan to
post RFC to net folks ...

Stanislaw
