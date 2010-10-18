Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:27114 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab0JROKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 10:10:25 -0400
Subject: Re: [PATCH v4 00/03] wl1271: 11n Support, add support to 80211n
 spec
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286978981-21467-1-git-send-email-shahar_levi@ti.com>
References: <1286978981-21467-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 17:09:13 +0300
Message-ID: <1287410953.20107.62.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-13 at 16:09 +0200, ext Shahar Levi wrote:
> Changes from v2:
> - Add logic on wl1271_op_bss_info_changed()
> - add CONFIG_WL1271_HT in tx & rx
> - Rebase to latest wl12xx git
> - Clean to Linux code style.
> 
> Changes from v3:
> - Fix HW_RX_HIGHEST_RATE to 72 (old value 65)
> - In wl1271_acx_set_ht_capabilities() replace ? with if 
> - Fix some comments
> - Clean to Linux code style.

Now it looks ok.  I have applied the patches.  Thanks!

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>


-- 
Cheers,
Luca.

