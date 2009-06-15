Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52010 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758865AbZFOUed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 16:34:33 -0400
Date: Mon, 15 Jun 2009 16:34:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	<linux-pci@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<ath5k-devel@venema.h4ckr.net>
Subject: Re: [linux-pm] PCI hotplug v.s. suspend
In-Reply-To: <200906152158.30989.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906151630440.2643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 15 Jun 2009, Rafael J. Wysocki wrote:

> > I'm not sure whether the example is trustworthy.  There was some
> > discussion quite a while ago regarding whether drivers should free
> > their IRQs during suspend, but I don't remember what the outcome was.
> 
> No, they shouldn't.
> 
> That's why we do the entire suspend_device_irqs() thing etc.

Looks like the Documentation/power/pci.txt file needs to be updated.  
No surprise, it hasn't been touched in well over a year and there 
haven't been any meaningful updates in four years.

Alan Stern

