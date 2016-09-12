Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57518 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932199AbcILKHE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 06:07:04 -0400
Message-ID: <1473674822.29016.6.camel@sipsolutions.net> (sfid-20160912_120849_903127_17D3D421)
Subject: Re: [PATCH] mac80211: fix sequence number assignment for PS
 response frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Mon, 12 Sep 2016 12:07:02 +0200
In-Reply-To: <521f75cd-2203-efc0-77c9-d9f7b6c4079f@nbd.name>
References: <20160904160059.66297-1-nbd@nbd.name>
         <1473674327.29016.3.camel@sipsolutions.net>
         <afb51baf-ec2d-3600-9e5b-f406b9e836b7@nbd.name>
         <1473674624.29016.4.camel@sipsolutions.net>
         <521f75cd-2203-efc0-77c9-d9f7b6c4079f@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-09-12 at 12:05 +0200, Felix Fietkau wrote:
> On 2016-09-12 12:03, Johannes Berg wrote:
> > 
> > 
> > > 
> > > Hm, I guess I didn't think of that. I guess this potential issue
> > > will
> > > go away once we get Toke's tx handler reorder patch fixed,
> > > rebased
> > > and integrated.
> > > 
> > 
> > I don't really see how that helps?
> It replaces the changes that I made.
> 

But this is a more general problem, no?

johannes
