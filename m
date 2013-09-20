Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39611 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab3ITONh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 10:13:37 -0400
Date: Fri, 20 Sep 2013 15:12:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: alsa-devel@alsa-project.org, b43-dev@lists.infradead.org,
	devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, e1000-devel@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Rob Landley <rob@landley.net>,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 01/51] DMA-API: provide a helper to set both DMA and
	coherent DMA masks
Message-ID: <20130920141244.GQ25647@n2100.arm.linux.org.uk> (sfid-20130920_161411_362517_D0C860CB)
References: <20130919212235.GD12758@n2100.arm.linux.org.uk> <E1VMlja-0007fA-HU@rmk-PC.arm.linux.org.uk> <1379640097.2500.4.camel@bwh-desktop.uk.level5networks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379640097.2500.4.camel@bwh-desktop.uk.level5networks.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 20, 2013 at 02:21:37AM +0100, Ben Hutchings wrote:
> On Thu, 2013-09-19 at 22:25 +0100, Russell King wrote:
> [...]
> > -dma_set_coherent_mask() will always be able to set the same or a
> > -smaller mask as dma_set_mask(). However for the rare case that a
> > +The coherent coherent mask will always be able to set the same or a
> > +smaller mask as the streaming mask. However for the rare case that a
> [...]
> 
> The new wording doesn't make sense; a mask doesn't set itself.  I would
> suggest:
> 
> "The coherent mask can always be set to the same or a smaller mask than
> the streaming mask."

Yes, the original sentence is not particularly good, but I think even
your modified version can be interpreted as "a mask setting itself"
for all the same reasons that the original can be (which mask does "same"
refer to?)

Even so, I prefer your version.  Thanks. :)
