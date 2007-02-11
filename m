Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:37337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXBKOra (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 09:47:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
Date: Sun, 11 Feb 2007 15:45:02 +0100
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <200702111514.04893.mb@bu3sch.de> <1171204910.5032.7.camel@johannes.berg>
In-Reply-To: <1171204910.5032.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702111545.04183.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, 11 February 2007 15:41, Johannes Berg wrote:
> On Sun, 2007-02-11 at 15:14 +0100, Michael Buesch wrote:
> 
> > > bcm43xx: IRQ_READY timeout
> > > bcm43xx: core_up for active 802.11 core failed (-19)
> > 
> > I never tried suspend to disk with the driver.
> > Larry, an idea why the microcode doesn't respond?
> 
> Rafael, is bcm43xx built in or modular?

Modular.  Otherwise I wouldn't have been able to reload it. :-)

Rafael
