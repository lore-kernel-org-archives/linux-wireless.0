Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from buzzloop.caiaq.de ([212.112.241.133]:35582 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab0DARAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 13:00:09 -0400
Date: Thu, 1 Apr 2010 19:00:04 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
	AKML <linux-arm-kernel@lists.infradead.org>,
	linux-wireless@vger.kernel.org,
	Sven Neumann <s.neumann@raumfeld.com>
Subject: Re: Memory corruption with 2.6.32.10, but not with 2.6.34-rc3
Message-ID: <20100401170004.GO30801@buzzloop.caiaq.de>
References: <20100401132156.GJ30807@buzzloop.caiaq.de>
 <20100401165056.GA1138@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100401165056.GA1138@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 01, 2010 at 09:50:56AM -0700, Greg KH wrote:
> On Thu, Apr 01, 2010 at 03:21:56PM +0200, Daniel Mack wrote:
> > So my current summary is that this is related to WiFi, but OTOH it still
> > only happens when file system traffic is issued.
> > 
> > We would like to have a fix for this annoying bug in the stable series
> > (especially 2.6.32.x) as well, but I don't have much ideas about where
> > to search for it. Hence, I would appreciate if maintainers could think
> > about any possible commits in the described time window which haven't
> > reached stable. Does the description ring anyone's bell?
> 
> I can't think of any USB specific patches that would be related to this,
> sorry.

Yes, I'd rule out USB anyway. It crashes without any USB function as
well. I just copied you as the maintainer of the stable tree :)

Daniel

