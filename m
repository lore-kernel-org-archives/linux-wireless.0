Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761304AbXF2NF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 09:05:57 -0400
Subject: Re: build #301 failed for 2.6.22-rc6-g0471448 in  drivers/net/wireless/libertas/usb8xxx.ko
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1183119024.30222.7.camel@xo-13-A4-25.localdomain>
References: <200706291117.35231.toralf.foerster@gmx.de>
	 <1183108826.4089.30.camel@johannes.berg>
	 <1183119024.30222.7.camel@xo-13-A4-25.localdomain>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 09:10:39 -0400
Message-Id: <1183122639.30222.55.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-06-29 at 08:10 -0400, Dan Williams wrote:
> On Fri, 2007-06-29 at 11:20 +0200, Johannes Berg wrote:
> > Hi,
> > 
> > > ERROR: "libertas_remove_mesh" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_add_card" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_send_tx_feedback" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_prepare_and_send_command" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_remove_card" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_add_mesh" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_process_rxed_packet" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_interrupt" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_activate_card" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > 
> > > CONFIG_LIBERTAS=y
> > > CONFIG_LIBERTAS_USB=m
> > 
> > looks like a bunch of missing EXPORT_SYMBOL(_GPL?) statements.
> 
> Thanks! I'll get that fixed up on Monday...

Unless of course somebody else gets there first, at which point I'm
happy to apply the patch.  I'd default to EXPORT_SYMBOL_GPL I guess
unless somebody has a great reason not too.

Dan


