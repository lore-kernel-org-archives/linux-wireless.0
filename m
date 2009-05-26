Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:41676 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZEZMpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 08:45:49 -0400
From: Ivo van Doorn <ivdoorn@gmail.com>
To: alejandro.riveira@gmail.com
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
Date: Tue, 26 May 2009 14:45:46 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linville@tuxdriver.com, Greg KH <greg@kroah.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <1243247687.5322.8.camel@varda> <200905261235.36658.IvDoorn@gmail.com> <1243341791.7607.4.camel@varda>
In-Reply-To: <1243341791.7607.4.camel@varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200905261445.46990.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > > What causes the regression then?
> > 
> > No idea. Apparently the invalid bitmask is accepted by the device under
> > certain conditions. Which would be very odd.... But since dozens
> > of people reported this problem for 2.6.27 as well, it probably depends
> > heavily on the actual chipset revision or configuration.
> > 
> > > Anyway For the script to work what config options do I need? debugfs?
> > > Anything else ?
> > 
> > CONFIG_DEBUGFS
> > CONFIG_MAC80211_DEBUGFS
> > CONFIG_RT2X00_LIB_DEBUGFS
> > 
> > And thats it, make sure debugfs is mounted and just run the script.
> > The script will detect mount location and rt2x00 interface.
> 
> 
> That's what I get[1] with the good kernel but I think the script failed
> because I got a very short output

Ok, that means it is the wrong script, try the other one from the download
location you previously refered to. I changed the API some time ago, and
am not sure which stable release that change will be in.

> [1] Had to install gawk mawk does not have --posix. 

Right, that was still something I needed to work on. :)

Ivo
