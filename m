Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:44839 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751101AbYA0TvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 14:51:12 -0500
From: David Brownell <david-b@pacbell.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 12/14] [rndis_host] Add RNDIS physical medium checking into generic_rndis_bind()
Date: Sun, 27 Jan 2008 11:51:09 -0800
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bjd@jooz.net
References: <20080125225032.11716.77713.stgit@fate.lan> <200801270829.53470.david-b@pacbell.net> <1201460746.3663.18.camel@localhost>
In-Reply-To: <1201460746.3663.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801271151.09988.david-b@pacbell.net> (sfid-20080127_195116_089173_27CA5E5C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 27 January 2008, Jussi Kivilinna wrote:
> 
> I'm not very familiar with posting patches (as some might have noticed)
> so I have some questions.. if you don't mind. Now that you have acked
> most of the patches, is it ok for me to add your 'Acked-by' to those
> patches?

On those patches I've acked, yes.  (Unless it's a different version
from what I acked...)  You may not need to re-send them ... that's
kind of a policy choice of the subsystem maintainer (Jeff Garzik in
this case).  Most maintainers pick up acks from the mailing list, as
part of their merge process.


> Should I even repost all of these patches as patchset or just 
> ones that have been fixed?

Again, that's a subsystem-specific policy.  In most cases I'm
familiar with, the answer is to avoid needless reposting ... so
after it's acked, at most one repost-with-ack.  (And typically
not even that, when maintainers pick up the acks.)

The main reason to repost an entire patch series is to avoid
confusion that creeps in with too many tweaked versions.  On
the other hand, such reposting creates its own confusion...


> Should I post new 'physical medium' patch as 
> reply to this post and then repost patchset with your ack just to
> mailing list?

My two cents:  just post an updated version of $SUBJECT.
If Jeff wants a version with the Acks, he'll tell you
(or someone more up on netdev policies will).

At this point, assuming you update $SUBJECT patch OK,
I think this series is ready for Jeff's attention...

- Dave
