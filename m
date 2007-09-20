Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2495 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbXITNll (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 09:41:41 -0400
Date: Thu, 20 Sep 2007 09:19:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg KH <gregkh@suse.de>
Cc: David Brownell <david-b@pacbell.net>,
	linux-usb-devel@lists.sourceforge.net, davem@davemloft.net,
	jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-usb-users@lists.sourceforge.net, zambrano@broadcom.com,
	mb@bu3sch.de
Subject: Re: Please pull 'ssb-drivers' branch of wireless-2.6
Message-ID: <20070920131900.GA6748@tuxdriver.com>
References: <20070919204428.GE5483@tuxdriver.com> <20070919213356.GB15510@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070919213356.GB15510@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2007 at 02:33:56PM -0700, Greg KH wrote:
> On Wed, Sep 19, 2007 at 04:44:28PM -0400, John W. Linville wrote:

> > These patches build upon the SSB bus support added to net-2.6.24 to
> > support the b43 wireless driver.  Since Dave has that support in his
> > tree, I'm asking him to merge these patches as well.

> > The second patch adds a driver for a USB OHCI device which lives on
> > the SSB bus.  Again, this is found on a number of SoC devices used
> > especially in wireless routers and APs.

> > The patches are available here:
> > 
> > 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/ssb-drivers/0001-b44-port-to-native-ssb-support.patch
> > 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/ssb-drivers/0002-usb-ssb-hosted-OHCI-driver.patch
> 
> This one needs to go through the linux-usb-devel list (not the -users
> list) and get acked by David Brownell, the current OHCI maintainer.

Ooops, sorry -- clicked on the wrong line in MAINTAINERS...

David, please review the patch in the second link above and consider it
for inclusion in 2.6.24 (once the SSB stuff in net-2.6.24 is merged).

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
