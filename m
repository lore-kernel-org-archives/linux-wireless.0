Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60568 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbZJZUBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 16:01:16 -0400
Date: Mon, 26 Oct 2009 15:51:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Azhar <Azhar.iq@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: TL-WN721N
Message-ID: <20091026195158.GK2792@tuxdriver.com>
References: <loom.20091015T161901-805@post.gmane.org> <20091015151058.GC2809@tuxdriver.com> <loom.20091018T103209-571@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20091018T103209-571@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 18, 2009 at 08:33:46AM +0000, Azhar wrote:
> John W. Linville <linville@...> writes:
> 
> > 
> > On Thu, Oct 15, 2009 at 02:20:52PM +0000, Azhar wrote:
> > > Hi all,
> > > 
> > > I am looking for drivers of TL-WN721N (for linux)...i have been going through
> > > pages aand pages of documentation....but every other link seems to route
> > > here...i would really appreciate if you could guide me
> > > 
> > > Thanks
> > > 
> > > Azhar
> > 
> > Is it PCI?  USB?  The output of lspci or lsusb would be helpful
> > to know.  Of course, in most cases you distribution would have the
> > driver auto-loaded for you if it was supported at all...
> > 
> > John
> 
> ndiswrapper -l
> 
> WARNING: All config files need .conf: /etc/modprobe.d/ndiswrapper, it will be
> ignored in a future release.
> WARNING: All config files need .conf: /etc/modprobe.d/blacklist, it will be
> ignored in a future release.
> netathur : driver installed
> device (0CF3:9271) present
> 
> 
> lsusb
> 
> Bus 001 Device 003: ID 0cf3:9271 Atheros Communications, Inc.

I suspect you should try a wireless-testing kernel or a bleeding-edge
wireless-compat package.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
