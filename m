Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45245
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbXBJGCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Feb 2007 01:02:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
Date: Sat, 10 Feb 2007 06:55:50 +0100
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Joseph Jezak <josejx@gentoo.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net> <45CCCAE1.9080901@lwfinger.net> <20070209213239.GA11650@srcf.ucam.org>
In-Reply-To: <20070209213239.GA11650@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702100655.51495.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 February 2007 22:32, Matthew Garrett wrote:
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

We don't know.

It's likely that old cards still work with v4 firmware, but we don't know and
it has to be tested.

Care to do so?
