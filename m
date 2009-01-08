Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65055 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZAHXWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 18:22:49 -0500
Message-ID: <20090108232249.2BHU8.228101.root@hrndva-web20-z02> (sfid-20090109_002253_825655_17F1CD8E)
Date: Thu, 8 Jan 2009 23:22:48 +0000
From: <lmage11@twcny.rr.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: Help debugging unexpected disassociations?
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1231456371.7467.103.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---- reinette chatre <reinette.chatre@intel.com> wrote: 
> On Thu, 2009-01-08 at 14:43 -0800, lmage11@twcny.rr.com wrote:
> > ---- lmage11@twcny.rr.com wrote: 
> > > Hey everyone. I'm using an Intel 4965AGN using the iwlagn
> > > driver in 2.6.28. When using a specific AP, my connection is
> > > unexpectedly dropping with nothing more than a
> > > "wlan0: deauthenticated". Any tips on how I could figure out
> > > whether this is the driver's fault or the AP's? Another problem I'm
> > > having is that dhcpcd is timing out a lot, usually after trying to
> > > reconnect from a connection drop.
> > > 
> > > The AP is a Linksys WRT54Gv1 with WPA2 and ssid broadcasting enabled.
> > > 
> > > Thanks!
> > > 
> > > Ari
> > 
> > Um... Bump?
> 
> This is very little information to go by. Does the log print a reason
> code? Could you please provide some debug logs? Ensure driver is
> compiled with debugging and load module with debug=0x43fff. 

No reason code. As I said, all I get is "wlan0: deauthenticated". I
have tried running with debug=0x43fff, but nothing jumped out
at me. I'll try to dig up some logs and post them.

Ari
