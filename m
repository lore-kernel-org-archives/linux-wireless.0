Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3198 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbXGTSdA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 14:33:00 -0400
Date: Fri, 20 Jul 2007 14:05:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Ehud Gavron <gavron@Wetwork.Net>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
Message-ID: <20070720180558.GG7428@tuxdriver.com>
References: <46963C0F.3080104@lwfinger.net> <20070719215801.GB12449@tuxdriver.com> <20070720012714.0dc0298a@morte> <46A01209.4030200@lwfinger.net> <1184906596.9511.42.camel@dv> <20070720134425.GC7428@tuxdriver.com> <1184947521.1962.15.camel@dv> <46A0E3F2.5080209@Wetwork.Net> <1184954268.1962.43.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1184954268.1962.43.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 20, 2007 at 01:57:48PM -0400, Pavel Roskin wrote:

> On Fri, 2007-07-20 at 09:33 -0700, Ehud Gavron wrote:

> > The driver should have a name that reflects its use and capabilities.
> 
> Not necessarily.  End users should be shielded from such details by
> distributions.  Do you know the name of the Windows driver for your
> network card?  Does it reflect "its use and capabilities"?
> 
> Now, if we are talking about power users, who can occasionally recompile
> the kernel or install a program not from the distribution, they would be
> helped by reasonable names of the drivers.
> 
> Also, distribution maintainers would feel better if the drivers are not
> renamed, so that /etc/modprobe.d/ doesn't need to be scanned for the old
> names on kernel upgrade.

ACK...fwiw, I like the "b43" name suggestion.  I wonder if that is
too prone to confusion w/ "b44"?  Probably no worse than "ixgb" vs
"cxgb3" or "e100" vs "e1000" I suppose.

John
-- 
John W. Linville
linville@tuxdriver.com
