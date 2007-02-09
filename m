Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47868 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752471AbXBIWwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 17:52:41 -0500
Date: Fri, 9 Feb 2007 23:52:34 +0100
From: Martin Langer <martin-langer@gmx.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Joseph Jezak <josejx@gentoo.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
Message-ID: <20070209225234.GA3381@tuba>
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net> <200702091811.40683.mb@bu3sch.de> <45CCF432.2070002@gentoo.org> <200702091829.51002.mb@bu3sch.de> <45CCBB93.2040703@lwfinger.net> <45CCC5DF.8010001@gentoo.org> <45CCCAE1.9080901@lwfinger.net> <20070209213239.GA11650@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070209213239.GA11650@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 09, 2007 at 09:32:39PM +0000, Matthew Garrett wrote:
> On Fri, Feb 09, 2007 at 01:26:25PM -0600, Larry Finger wrote:
> 
> > My plan is to continue to maintain bcm43xx-SoftMAC for at least the BPHY and 4306 revisions even
> > after d80211 becomes the in-kernel driver. Of course, I hope that we will have found the killer bugs
> > by that time, and that maintenance will only require following kernel API changes.
> 
> Just to make sure I'm understanding this correctly - does the v4 
> firmware drop compatibility for older cards, or is it just that Broadcom 
> dropped support in the driver at the same time as the firmware changed, 
> and the new firmware will still also drive the old cards?

We can't extract bcm43xx_microcode2.fw from v4 drivers. You need this 
file for old rev2+3 0x812 cores. So we don't know what firmware we 
should load into those old cores. I think broadcom never developed a new 
v4 style firmware for their old hardware.

Martin


