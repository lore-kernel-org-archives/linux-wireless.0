Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2252 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761269AbXHWVPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 17:15:08 -0400
Date: Thu, 23 Aug 2007 16:58:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Guido Guenther <agx@sigxcpu.org>,
	at76c503a-develop@lists.berlios.de
Subject: Re: at76_usb - fourth submission attempt
Message-ID: <20070823205851.GK2989@tuxdriver.com>
References: <1184228166.2377.31.camel@dv> <20070712201702.72209493@griffin.suse.cz> <1184265547.29486.2.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1184265547.29486.2.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 12, 2007 at 02:39:07PM -0400, Pavel Roskin wrote:
> On Thu, 2007-07-12 at 20:17 +0200, Jiri Benc wrote:

> > > The biggest change that has not been done is conversion to mac80211.  I
> > > believe it's possible, but I don't expect it to happen overnight.  Until
> > > then, at76_usb uses its own implementation of 802.11 protocol.
> > 
> > Unfortunately, that prevents being accepted to vanilla.
> > 
> > I'd suggest to convert the driver to mac80211 and submit it then;
> > otherwise people will tend to look at the code saying "NAK, it contains
> > its own home grown 802.11 stack" only and not to review the driver in
> > depth.
> 
> Well, that make sense.  Helpers are welcome :)

I have added this to the 'at76' branch of wireless-dev, and attempted
to directly recruit some help to get this driver ported to mac80211.
I think that is a requirement for merging upstream, but at least
being in wireless-dev and -mm will get you some visibility, testing,
feedback, etc...

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
