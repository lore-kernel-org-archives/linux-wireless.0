Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbXI2EzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 00:55:24 -0400
Subject: Re: [PATCH] libertas: fix link errors (bz# 9077)
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless@vger.kernel.org, rjwysocki@sisk.pl
In-Reply-To: <20070927203650.GD7991@tuxdriver.com>
References: <20070927101742.44146651.randy.dunlap@oracle.com>
	 <1190915263.5021.8.camel@johannes.berg>
	 <20070927203650.GD7991@tuxdriver.com>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 00:51:07 -0400
Message-Id: <1191041467.9155.11.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-09-27 at 16:36 -0400, John W. Linville wrote:
> On Thu, Sep 27, 2007 at 07:47:43PM +0200, Johannes Berg wrote:
> > On Thu, 2007-09-27 at 10:17 -0700, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Fix missing symbols in libertas USB driver when it is modular and rest
> > > of libertas is built-in.
> > 
> > Ohhh. Thanks Randy, I stared at this problem for a while and never
> > noticed that it said _USB there.
> 
> FWIW, the equivalent change seems to already be in net-2.6.24.

I 100% certain this was fixed in libertas-2.6 months ago, but my hunch
is that it got blown away when I rebased the 70-odd libertas-2.6 patches
on top of 2.6.23 to send to linville for the 2.6.24 cycle.  That section
specifically conflicted with the addition of the zd1211 driver's config
variable.  Yay for merging, sorry...

Dan


