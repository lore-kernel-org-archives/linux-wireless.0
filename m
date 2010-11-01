Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59091 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab0KAOWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 10:22:21 -0400
Subject: Re: [PATCH v3b] linux-firmware: wl12xx-Add Firmware and NVS files
 to support Texas Instruments WLAN driver
From: David Woodhouse <dwmw2@infradead.org>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1286118243-10633-1-git-send-email-shahar_levi@ti.com>
References: <1286118243-10633-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 10:21:58 -0400
Message-ID: <1288621318.26983.29.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-10-03 at 17:04 +0200, Shahar Levi wrote:
> FW & NVS Support wl127x wireless LAN driver (wl1271 & wl1273).
> In order to use those files copy them to target FS at /lib/firmware/.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> Tested-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---
> Changes from v1:
> - Update the wl1271-nvs.bin that support a band to the correct size (912B)
> Changes from v2:
> - convert LICENCE file to UTF-8 (clean 0xA0) and fit in 80 columns

Still crap in LICENCE.ti-connectivity. It starts with a gratuitous
U+FEFF unicode byte-order mark. I've removed that myself and committed
it.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

