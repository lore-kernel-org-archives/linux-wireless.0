Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39750 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3IUUJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Sep 2013 16:09:21 -0400
Date: Sat, 21 Sep 2013 21:00:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
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
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 24/51] DMA-API: dma: pl330: add
	dma_set_mask_and_coherent() call
Message-ID: <20130921200000.GS25647@n2100.arm.linux.org.uk> (sfid-20130921_220953_003140_C46CB6E1)
References: <20130919212235.GD12758@n2100.arm.linux.org.uk> <E1VMm5t-0007i5-V7@rmk-PC.arm.linux.org.uk> <201309201926.29084.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <201309201926.29084.heiko@sntech.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 20, 2013 at 07:26:27PM +0200, Heiko Stübner wrote:
> Am Donnerstag, 19. September 2013, 23:49:01 schrieb Russell King:
> > The DMA API requires drivers to call the appropriate dma_set_mask()
> > functions before doing any DMA mapping.  Add this required call to
> > the AMBA PL08x driver.
> 			^--- copy and paste error - should of course be PL330

Fixed, thanks.
