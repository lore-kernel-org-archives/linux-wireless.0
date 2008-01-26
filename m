Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58939
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752946AbYAZNqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 08:46:15 -0500
Date: Sat, 26 Jan 2008 05:46:28 -0800 (PST)
Message-Id: <20080126.054628.152453178.davem@davemloft.net> (sfid-20080126_134617_751084_20159BF1)
To: torvalds@linux-foundation.org
Cc: mb@bu3sch.de, inaky@linux.intel.com, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0801251350090.5056@hp.linux-foundation.org>
References: <200801251311.45392.inaky@linux.intel.com>
	<200801252221.07558.mb@bu3sch.de>
	<alpine.LFD.1.00.0801251350090.5056@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Jan 2008 13:54:31 -0800 (PST)

> 
> 
> On Fri, 25 Jan 2008, Michael Buesch wrote:
> > > Well, you forgot the point that maybe it is not that simple to get such
> > > a seemingly simple change into the firmware for a long list of reasons.
> > 
> > The reasons being?
> 
> .. the reason being that people just expect existing firmware to work, for 
> example.
> 
> The point being, even if a newer firmware was _available_, people wouldn't 
> necessarily run with it.

How differently would the situation be handled if the firmware
source were available and changeable by anyone in the community?

This situation therefore only exists because it is not available
to anyone to hack on.

Drivers like the aic7xxx and sym53c8xx scsi ones come with scripts
and other firmware that we build, if a bug were found in it we
would simply fix it instead of bastardizing the C portions of
the driver to fit the limitations of the firmware.

The firmware is source, just that in this case we don't have
access to a usable form of it, and the entity that does chooses
to not band over a little bit to be cooperative.
