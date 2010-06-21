Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11329 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab0FUKpq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 06:45:46 -0400
Date: Mon, 21 Jun 2010 12:45:46 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [RFC PATCHv2 1/2] cfg80211/mac80211: Update set_tx_power to
 use mBm instead of dBm units
Message-ID: <20100621104546.GC3271@sortiz-mobl>
References: <1277116766-4764-1-git-send-email-juuso.oikarinen@nokia.com>
MIME-Version: 1.0
In-Reply-To: <1277116766-4764-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 21, 2010 at 11:39:25AM +0100, Juuso Oikarinen wrote:
> In preparation for a TX power setting interface in the nl80211, change the
> .set_tx_power function to use mBm units instead of dBm for greater accuracy and
> smaller power levels.
> 
> Also, already in advance move the tx_power_setting enumeration to nl80211.
> 
> This change affects the .tx_set_power function prototype. As a result, the
> corresponding changes are needed to modules using it. These are mac80211,
> iwmc3200wifi and rndis_wlan.
For the iwm part:
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

