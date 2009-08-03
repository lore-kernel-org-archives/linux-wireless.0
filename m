Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49435 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZHCVI1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 17:08:27 -0400
Subject: Re: iwlagn: possible regressions from 2.6.29 in 2.6.30
From: reinette chatre <reinette.chatre@intel.com>
To: Paul Collins <paul@burly.ondioline.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87tz1thrzk.fsf@bulky.wgtn.ondioline.org>
References: <874oty9tlf.fsf@bulky.wgtn.ondioline.org>
	 <1246378651.17896.523.camel@rc-desk>	<87k52t9ynp.fsf@jenny.ondioline.org>
	 <87tz1thrzk.fsf@bulky.wgtn.ondioline.org>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 14:08:13 -0700
Message-Id: <1249333693.30019.4285.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paul,

Hi Paul,

On Fri, 2009-07-03 at 23:39 -0700, Paul Collins wrote:
> Paul Collins <paul@burly.ondioline.org> writes:
> 
> > reinette chatre <reinette.chatre@intel.com> writes:
> >>> When I say "packets > 250 bytes" I mean 250-byte packets as claimed by
> >>> "ping -s 222 mygateway":
> >>> 
> >>>         PING cornelius.lan (10.2.4.1) 222(250) bytes of data.
> >>> 
> >>> The above will work, but "ping -s 223 cornelius" yields no replies.
> >>
> >> Are you saying this works before suspend, but not after resume? What do
> >> you usually do to get this working again?
> >
> > Yes, normally it works great; I can ping with packet sizes up to the
> > MTU.  However, after suspend/resume and reassociation, "ping -s 223" or
> > greater does not work.  I get replies with "-s 222" or less,
> > i.e. packets of 250 bytes or less.
> >
> > To get it working again I do "ifdown wlan0" followed by "ifup wlan0",
> > which does the equivalent of "ip set link wlan0 down/up" and applying
> > the network configuration.
> >
> > I will give the patch a shot when I get home.
> 
> I thought at first that the patch had moved the problem from reliably
> reproducible to intermittently reproducible, but it looks like it was
> simply intermittently reproducible the whole time.  So, no change with
> the patch applied.

We have not yet been able to look into this issue - could you please
submit a bug at intellinuxwireless.org/bugzilla so that we can track it
there? 

Thank you

Reinette


