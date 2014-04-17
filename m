Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaDQTgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 15:36:49 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Jonathan McDowell <noodles@earth.li>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: [Ilw] Re: Intel 7260 not working in 802.11n mode
Date: Thu, 17 Apr 2014 19:36:43 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303DCC93F@HASMSX103.ger.corp.intel.com> (sfid-20140417_213653_487699_7B9DC028)
References: <20140407003648.GA19740@earth.li>
 <CANUX_P3H=F1C1H6NvdvpTHQh1JqvPjvyUjAygSQgeNyZ-q6=ZQ@mail.gmail.com>
 <20140407064556.GN24850@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB303DC6723@HASMSX103.ger.corp.intel.com>
 <20140407152312.GO24850@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB303DCA5EC@HASMSX103.ger.corp.intel.com>
 <20140416061043.GZ24850@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB303DCC00F@HASMSX103.ger.corp.intel.com>
 <20140417173118.GC24850@earth.li>
In-Reply-To: <20140417173118.GC24850@earth.li>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Wed, Apr 16, 2014 at 07:58:01PM +0000, Grumbach, Emmanuel wrote:
> > > > I really can't see anything bad in this log.
> > > > Can you run tracing?
> > > >
> > > > sudo trace-cmd record -e iwlwifi -e iwlwifi_msg -e mac80211 -e
> > > > cfg80211
> > > >
> > > > this will create a trace.dat file which I'd like to look at.
> > >
> > > http://the.earth.li/~noodles/iwlwifi/broken-trace.dat.xz
> > >
> > > and for completeness, with disable_11n=1:
> > >
> > > http://the.earth.li/~noodles/iwlwifi/working-trace.dat.xz
> > >
> > > In both cases I started the trace, flipped the hardware wifi disable
> > > switch, let Network Manager do its thing.
> > >
> > Thanks for this. I am on vacation right now and won't be able to look
> > at this straight away.
> >
> > Please don't remove the files from your web server.  Also - if you can
> > open a bug on bugzilla.kernel.org - this would be best.  Cc
> > ilw@linux.intel.com to your bug. Thanks!
> 
> No problem; bug 74311 raised. I'll leave the files around.
> 

Many thanks - see you there.
