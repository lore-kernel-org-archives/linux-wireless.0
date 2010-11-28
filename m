Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from void.printf.net ([89.145.121.20]:48499 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab0K1Cj1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Nov 2010 21:39:27 -0500
Date: Sun, 28 Nov 2010 02:39:24 +0000
From: Chris Ball <cjb@laptop.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH] omap: zoom: wl1271 slot is MMC_CAP_POWER_OFF_CARD
Message-ID: <20101128023924.GA6019@void.printf.net>
References: <1290815964-30088-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1290815964-30088-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, Nov 27, 2010 at 01:59:24AM +0200, Ohad Ben-Cohen wrote:
> This patch complements ed919b0 "mmc: sdio: fix runtime PM anomalies by
> introducing MMC_CAP_POWER_OFF_CARD" by declaring MMC_CAP_POWER_OFF_CARD
> on the ZOOM's wl1271 mmc slot.
> 
> This is required in order not to break runtime PM support for the wl1271
> sdio driver.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

Looks good.  Tony, feel free to take this for .37 through your tree.

Signed-off-by: Chris Ball <cjb@laptop.org>

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
