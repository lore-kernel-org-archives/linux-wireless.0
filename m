Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36786 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab0JaIHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Oct 2010 04:07:11 -0400
Message-ID: <4CCD239A.3010506@ti.com>
Date: Sun, 31 Oct 2010 10:06:50 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH v3b] linux-firmware: wl12xx-Add Firmware and NVS files
 to support Texas Instruments WLAN driver
References: <1286118243-10633-1-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1286118243-10633-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2010 05:04 PM, Levi, Shahar wrote:
> FW&  NVS Support wl127x wireless LAN driver (wl1271&  wl1273).
> In order to use those files copy them to target FS at /lib/firmware/.
>
> Signed-off-by: Shahar Levi<shahar_levi@ti.com>
> Tested-by: Luciano Coelho<luciano.coelho@nokia.com>
> ---
> Changes from v1:
> - Update the wl1271-nvs.bin that support a band to the correct size (912B)
> Changes from v2:
> - convert LICENCE file to UTF-8 (clean 0xA0) and fit in 80 columns
[...]

Dear David,
I would greatly appreciate if you update when that patch will be apply 
to linux-firmware.

Thank you in advance.
Regards,
Shahar
