Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:35419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbXISVdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 17:33:44 -0400
Date: Wed, 19 Sep 2007 14:33:56 -0700
From: Greg KH <gregkh@suse.de>
To: "John W. Linville" <linville@tuxdriver.com>,
	David Brownell <david-b@pacbell.net>,
	linux-usb-devel@lists.sourceforge.net
Cc: davem@davemloft.net, jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-usb-users@lists.sourceforge.net, zambrano@broadcom.com,
	mb@bu3sch.de
Subject: Re: Please pull 'ssb-drivers' branch of wireless-2.6
Message-ID: <20070919213356.GB15510@suse.de>
References: <20070919204428.GE5483@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070919204428.GE5483@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2007 at 04:44:28PM -0400, John W. Linville wrote:
> Jeff, Greg, Gary, and Dave,
> 
> These patches build upon the SSB bus support added to net-2.6.24 to
> support the b43 wireless driver.  Since Dave has that support in his
> tree, I'm asking him to merge these patches as well.
> 
> The first patch changes b44 from being a PCI (i.e. SSB-in-drag)
> device to being a native SSB device.  This has little effect one
> way or the other for laptop/desktop/server machines.  But, some
> embedded devices have b44 hardware but no PCI bus (i.e. just SSB).
> This patch enables the use of the b44 driver on that hardware.
> 
> The second patch adds a driver for a USB OHCI device which lives on
> the SSB bus.  Again, this is found on a number of SoC devices used
> especially in wireless routers and APs.
> 
> Thanks for reviewing/ACKing/merging!
> 
> John
> 
> ---
> 
> The patches are available here:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/ssb-drivers/0001-b44-port-to-native-ssb-support.patch
> 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/ssb-drivers/0002-usb-ssb-hosted-OHCI-driver.patch

This one needs to go through the linux-usb-devel list (not the -users
list) and get acked by David Brownell, the current OHCI maintainer.

thanks,

greg k-h
