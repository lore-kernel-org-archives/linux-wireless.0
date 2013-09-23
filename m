Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23065 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab3IWLec (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 07:34:32 -0400
Date: Mon, 23 Sep 2013 16:13:52 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
	alsa-devel@alsa-project.org, linux-doc@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-ide@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-samsung-soc@vger.kernel.org,
	linux-scsi@vger.kernel.org, e1000-devel@lists.sourceforge.net,
	b43-dev@lists.infradead.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
	netdev@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [alsa-devel] [PATCH 24/51] DMA-API: dma: pl330: add
 dma_set_mask_and_coherent() call
Message-ID: <20130923104352.GK17188@intel.com> (sfid-20130923_133445_998906_D9CC35AE)
References: <20130919212235.GD12758@n2100.arm.linux.org.uk>
 <E1VMm5t-0007i5-V7@rmk-PC.arm.linux.org.uk>
 <201309201926.29084.heiko@sntech.de>
 <20130921200000.GS25647@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20130921200000.GS25647@n2100.arm.linux.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 21, 2013 at 09:00:00PM +0100, Russell King - ARM Linux wrote:
> On Fri, Sep 20, 2013 at 07:26:27PM +0200, Heiko Stübner wrote:
> > Am Donnerstag, 19. September 2013, 23:49:01 schrieb Russell King:
> > > The DMA API requires drivers to call the appropriate dma_set_mask()
> > > functions before doing any DMA mapping.  Add this required call to
> > > the AMBA PL08x driver.
> > 			^--- copy and paste error - should of course be PL330
> 
> Fixed, thanks.
with fixed changelog...

Acked-by: Vinod Koul <vinod.koul@intel.com>

~Vinod

-- 
