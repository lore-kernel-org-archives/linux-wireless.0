Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:48111 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbYCZCcw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 22:32:52 -0400
Subject: Re: Question on Wireless NICs
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Balaji Rao <balajirrao@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20080325193219.GC30587@tuxdriver.com>
References: <200803260011.29045.balajirrao@gmail.com>
	 <20080325193219.GC30587@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 22:32:48 -0400
Message-Id: <1206498769.23595.6.camel@dv> (sfid-20080326_023255_256958_44662760)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-03-25 at 15:32 -0400, John W. Linville wrote:

> The gPXE (formerly etherboot) project seems to support PCI-based
> (e.g. cardbus, but not PCMCIA) orinoco devices.  I cannot verify that,
> since I have no such device (donations accepted!)...

Just to set the record straight, I'm unaware of any CardBus devices
compatible with the orinoco driver, i.e. Prism 2-3, Symbol Trilogy or
Hermes I based 802.11b device.

At the first glance, gPXE appears to support Prism chipset only, either
native PCI or PCMCIA behind PLX9052 bridge.

-- 
Regards,
Pavel Roskin
