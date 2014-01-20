Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35128 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbaATUcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 15:32:42 -0500
Date: Mon, 20 Jan 2014 20:32:38 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Frank Huang <frankh@marvell.com>
Message-ID: <20140120203238.GT18005@decadent.org.uk> (sfid-20140120_213253_188988_1FCFC978)
References: <1389325691-21371-1-git-send-email-bzhao@marvell.com>
 <1390174797.3651.7.camel@deadeye.wl.decadent.org.uk>
 <477F20668A386D41ADCC57781B1F70430F53691E15@SC-VEXCH1.marvell.com>
 <1390186665.3651.27.camel@deadeye.wl.decadent.org.uk>
 <477F20668A386D41ADCC57781B1F70430F53691FC8@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F53691FC8@SC-VEXCH1.marvell.com>
Subject: Re: linux-firmware: pull-request Marvell mwifiex-firmware 2014-01-09
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 20, 2014 at 12:26:47PM -0800, Bing Zhao wrote:
> Hi Ben,
> 
> > > > >  File: mrvl/usb8797_uapsta.bin
> > > > > -Version: 14.69.11.p179
> > > > > +Version: 14.68.29.p26
> > > > [...]
> > > >
> > > > Why are these updates rolling the version number backward?  Did the
> > > > later versions cause regressions?
> > >
> > > These images are newer firmware versions actually.
> > >
> > > The 2nd (69 or 68) and 3rd (11 or 29) numbers in the version string do
> > > not necessarily mean the version increasing or decreasing. Only when
> > > first 3 numbers are fixed, a smaller 4th number will mean that the
> > > version is rolling backward. For examples,
> > 
> > So what do you they mean and why are they in the version number?
> 
> The first 3 numbers altogether identifies the firmware branch/features. The 4th number is the firmware revision.

This is a uniquely confusing way of generating version numbers.  If
only the current 4th part (what you call firmware revision) follows
the usual version ordering, then I think that should be used as the
(public) version number.

Ben.

-- 
Ben Hutchings
Gates has joked that everything goes on and off unexepectedly in the house,
which is run by a high-end PC network built on Windows NT. - Seattle Times
