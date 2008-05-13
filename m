Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2930 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbYEMOu4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 10:50:56 -0400
Date: Tue, 13 May 2008 10:28:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Christian =?iso-8859-1?Q?Sch=E4fer?= <schaefer@in.tum.de>,
	linux-wireless@vger.kernel.org
Subject: Re: BUG: scheduling while atomic: rt73usb
Message-ID: <20080513142826.GC6273@tuxdriver.com> (sfid-20080513_165102_181933_9816274C)
References: <482952C3.9020209@in.tum.de> <1210669171.3646.49.camel@johannes.berg> <200805131310.19980.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805131310.19980.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 01:10:19PM +0200, Ivo van Doorn wrote:
> On Tuesday 13 May 2008, Johannes Berg wrote:
> > 
> > >   [<f929715a>] rt2x00lib_config_erp+0x7a/0xb0 [rt2x00lib]
> > >   [<f929623c>] rt2x00lib_intf_scheduled_iter+0x9c/0xf0 [rt2x00lib]
> > >   [<f9309841>] ieee80211_iterate_active_interfaces+0x71/0xa0 [mac80211]
> > 
> > If I read this correctly, it was recently fixed (but not committed yet
> > afaict)
> 
> Yes, the fix was send as part of a pull request from rt2x00.git,
> and I've requested it to be merged for 2.6.26 as well.

Hmmmm...is that "mac80211: Add RTNL version of
ieee80211_iterate_active_interfaces"?  I didn't see any indication
that one was for 2.6.26.  If it is, I'll get it out with the next
round of fixes.

John
-- 
John W. Linville
linville@tuxdriver.com
