Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47492 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbZAHXLP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 18:11:15 -0500
Subject: Re: Help debugging unexpected disassociations?
From: reinette chatre <reinette.chatre@intel.com>
To: "lmage11@twcny.rr.com" <lmage11@twcny.rr.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090108224343.F9TJC.227705.root@hrndva-web20-z02>
References: <20090108224343.F9TJC.227705.root@hrndva-web20-z02>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 15:12:51 -0800
Message-Id: <1231456371.7467.103.camel@rc-desk> (sfid-20090109_001119_805104_9C6BA7A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-01-08 at 14:43 -0800, lmage11@twcny.rr.com wrote:
> ---- lmage11@twcny.rr.com wrote: 
> > Hey everyone. I'm using an Intel 4965AGN using the iwlagn
> > driver in 2.6.28. When using a specific AP, my connection is
> > unexpectedly dropping with nothing more than a
> > "wlan0: deauthenticated". Any tips on how I could figure out
> > whether this is the driver's fault or the AP's? Another problem I'm
> > having is that dhcpcd is timing out a lot, usually after trying to
> > reconnect from a connection drop.
> > 
> > The AP is a Linksys WRT54Gv1 with WPA2 and ssid broadcasting enabled.
> > 
> > Thanks!
> > 
> > Ari
> 
> Um... Bump?

This is very little information to go by. Does the log print a reason
code? Could you please provide some debug logs? Ensure driver is
compiled with debugging and load module with debug=0x43fff. 

Reinette

