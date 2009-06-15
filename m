Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:45885 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbZFOUvf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 16:51:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] PCI hotplug v.s. suspend
Date: Mon, 15 Jun 2009 22:51:50 +0200
Cc: linux-pm@lists.linux-foundation.org,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	linux-pci@vger.kernel.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@venema.h4ckr.net
References: <Pine.LNX.4.44L0.0906151630440.2643-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906151630440.2643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200906152251.51648.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 June 2009, Alan Stern wrote:
> On Mon, 15 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > I'm not sure whether the example is trustworthy.  There was some
> > > discussion quite a while ago regarding whether drivers should free
> > > their IRQs during suspend, but I don't remember what the outcome was.
> > 
> > No, they shouldn't.
> > 
> > That's why we do the entire suspend_device_irqs() thing etc.
> 
> Looks like the Documentation/power/pci.txt file needs to be updated.  
> No surprise, it hasn't been touched in well over a year and there 
> haven't been any meaningful updates in four years.

Sure it does, but PCI PM has been a moving target for quite some time.  I hope
it's going to settle down now.

Best,
Rafael
