Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3562 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590AbYKJB7p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 20:59:45 -0500
Subject: Re: [PATCH 2/2] iwlwifi: enable custom fw regulatory solution
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1226109668-13778-3-git-send-email-lrodriguez@atheros.com>
References: <1226109668-13778-1-git-send-email-lrodriguez@atheros.com>
	 <1226109668-13778-2-git-send-email-lrodriguez@atheros.com>
	 <1226109668-13778-3-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 10:00:01 +0800
Message-Id: <1226282401.2604.285.camel@debian.sh.intel.com> (sfid-20081110_025954_102495_FF92EF71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-11-08 at 10:01 +0800, Luis R. Rodriguez wrote:
> This enables the custom firmware regulatory solution option
> on iwlwifi drivers. These devices are uncapable of mapping their
> EEPROM regulatory domain to a specific ISO / IEC alpha2.
> Although the new 11n devices (>= iwl 50000) have only
                                       ^^^^^
Should be 5000.

> 3 regultaory SKUs -- MOW, ABG (no N) and BG -- the older
> devices (3945 and 4965) have a more complex SKU arrangement
> and therefore its not practical to move this to the driver.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

