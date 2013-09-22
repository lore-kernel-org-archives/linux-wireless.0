Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:65141 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3IVN3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 09:29:00 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so2165763wes.28
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 06:28:59 -0700 (PDT)
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 22/51] DMA-API: amba: get rid of separate dma_mask
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	alsa-devel@alsa-project.org, b43-dev@lists.infradead.org,
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
	uclinux-dist-devel@blackfin.uclinux.org
Cc: Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <E1VMm3x-0007hp-Lv@rmk-PC.arm.linux.org.uk>
References: <20130919212235.GD12758@n2100.arm.linux.org.uk> <E1VMm3x-0007hp-Lv@rmk-PC.arm.linux.org.uk>
Date: Sun, 22 Sep 2013 07:18:28 -0500
Message-Id: <20130922121828.58F02C42373@trevor.secretlab.ca> (sfid-20130922_152955_104781_10542A3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 19 Sep 2013 22:47:01 +0100, Russell King <rmk+kernel@arm.linux.org.uk> wrote:
> AMBA Primecell devices always treat streaming and coherent DMA exactly
> the same, so there's no point in having the masks separated.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

for the drivers/of/platform.c portion:
Acked-by: Grant Likely <grant.likely@linaro.org>

g.
