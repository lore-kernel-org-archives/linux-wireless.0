Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51809 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964800AbbGQIzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 04:55:24 -0400
Message-ID: <1437123321.1933.2.camel@sipsolutions.net> (sfid-20150717_105534_200515_2D28988A)
Subject: Re: [PATCH] iw:  Use ifname if available, print new/del/stop events.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Jul 2015 10:55:21 +0200
In-Reply-To: <55817A0F.2000207@candelatech.com>
References: <1433974675-19225-1-git-send-email-greearb@candelatech.com>
	 <1434532497.1884.27.camel@sipsolutions.net>
	 <55817A0F.2000207@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-17 at 06:45 -0700, Ben Greear wrote:
> 
> On 06/17/2015 02:14 AM, Johannes Berg wrote:
> > On Wed, 2015-06-10 at 18:17 -0400, greearb@candelatech.com wrote:
> > > From: Ben Greear <greearb@candelatech.com>
> > > 
> > > If the kernel sends the IFNAME in the netlink message, then
> > > use it to save the call to map ifindex to name (and
> > > potentially fix races, especially when kernel is
> > > busy deleting an interface.
> > 
> > Please split the "print new/del/stop events" part into a separate 
> > patch
> > - I can apply that now.
> 
> Some existing events (interface-delete, I think) already have the 
> ifname, by the way..so the iw patch
> is useful without any kernel changes.
> 

Fair enough. Still, splitting the patch would make sense I think.

johannes
