Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2836 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161233AbXBUNvk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 08:51:40 -0500
Date: Wed, 21 Feb 2007 08:32:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, jbenc@suse.cz
Subject: Re: [RFC PATCH] d80211: fix build break from netdev class_device -> device changes
Message-ID: <20070221133202.GB4978@tuxdriver.com>
References: <20070221005811.GA3875@tuxdriver.com> <1172054717.3705.1.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1172054717.3705.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 21, 2007 at 11:45:16AM +0100, Johannes Berg wrote:
> On Tue, 2007-02-20 at 19:58 -0500, John W. Linville wrote:
> > In preparation for 2.6.21-rc1, I pulled Linus' latest tree into a
> > branch of wireless-dev.  I hit a build problem with the sysfs stuff,
> > due to the recent changes from class_device -> device for net_device.
> 
> Hmm, need to look up the reason and see if wiphy stuff should follow.

Exactly what I was thinking, and what made me question the patch's
completeness...
 
> > Since I don't count sysfs as a strength, I thought it was worth
> > posting this for some review before I actually pulled Linus' latest
> > into wireless-dev and slapped this on top of it... :-)
> > 
> > Comments?
> 
> Seems fine. Is to_net_dev() defined in netdevice.h now?
 
Ja.

> OTOH, we might want to take this opportunity and move it all to
> debugfs ;)

Excellent suggestion.  But for now, I just want my tree to build and
run... :-)

Thanks for the eyeballs!

John
-- 
John W. Linville
linville@tuxdriver.com
