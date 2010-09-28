Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:32445 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab0I1Od5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 10:33:57 -0400
Subject: Re: [PATCH v2] linux-firmware: wl12xx-Add Firmware and NVS files
 to support Texas Instruments WLAN driver
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285682308-20189-1-git-send-email-shahar_levi@ti.com>
References: <1285682308-20189-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 17:33:48 +0300
Message-ID: <1285684428.4728.1.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 15:58 +0200, ext Shahar Levi wrote:
> FW & NVS Support wl127x wireless LAN driver (wl1271 & wl1273).
> In order to use those files copy them to target FS at /lib/firmware/.
> 
> Changes from v1:
> - Update the wl1271-nvs.bin that support a band to the correct size (912B)

It doesn't matter much, in my opinion, but this "Changes from v1"
shouldn't be in the actual commit log.  If you put this kind of comment
after the --- (below marked with <HERE>), it is informative for whoever
is reading your patch email, but it won't go into git history (where
this information is a useless, because v1 is not there).


> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

I'll test this patch soon and see if the NVS works now.

-- 
Cheers,
Luca.

