Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52071 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0IPRp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 13:45:28 -0400
Date: Thu, 16 Sep 2010 10:45:12 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-arm-kernel@lists.infradead.org,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>
Subject: Re: [PATCH v6 7/7] omap: zoom: add mmc3/wl1271 device support
Message-ID: <20100916174512.GD29610@atomide.com>
References: <1284593551-30141-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1284593551-30141-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Ohad Ben-Cohen <ohad@wizery.com> [100915 16:23]:
> Add MMC3 support on ZOOM, which has the wl1271 device hardwired to.
> 
> The wl1271 is a 4-wire, 1.8V, embedded SDIO WLAN device with an
> external IRQ line, and power-controlled by a GPIO-based fixed regulator.

Acked-by: Tony Lindgren <tony@atomide.com>
