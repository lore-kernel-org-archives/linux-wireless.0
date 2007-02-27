Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nuim.ie ([149.157.1.19]:63833 "EHLO LARCH.MAY.IE"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbXB0XcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 18:32:05 -0500
Date: Tue, 27 Feb 2007 17:00:00 +0000
From: Gavin McCullagh <gavin.mccullagh@nuim.ie>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
In-reply-to: <20070210125707.GA21803@srcf.ucam.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <larry.finger@lwfinger.net>,
	Joseph Jezak <josejx@gentoo.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de
Reply-to: Gavin McCullagh <gavin.mccullagh@nuim.ie>
Message-id: <20070227170000.GZ12087@nuim.ie>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>
 <45CCCAE1.9080901@lwfinger.net> <20070209213239.GA11650@srcf.ucam.org>
 <200702100655.51495.mb@bu3sch.de> <20070210125707.GA21803@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, 10 Feb 2007, Matthew Garrett wrote:

> On Sat, Feb 10, 2007 at 06:55:50AM +0100, Michael Buesch wrote:
> 
> > It's likely that old cards still work with v4 firmware, but we don't know and
> > it has to be tested.
> > 
> > Care to do so?
> 
> I'll check the revision of my 4306, but I think it's probably too new to 
> be useful, unfortunately...

I have a fairly old 4306 at home which I was lent by my boss and I've been
struggling to get it working for the past week or two.  What I find is that
loads of firmwares which I try with bcm43xx-fwcutter complain about the
firmware being old but then when I get a firmware which is not too old the
device registers but doesn't seem to work -- iwlist can't see any access
points and when I set the essid it doesn't associate with the AP.

Can I be helpful as a tester?

Gavin

