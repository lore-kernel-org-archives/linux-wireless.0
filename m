Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:33847 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab0FUTb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 15:31:28 -0400
Message-ID: <20100621223126.1179355zlbe4uqkw@hayate.sektori.org>
Date: Mon, 21 Jun 2010 22:31:26 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Juuso Oikarinen" <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org,
	"Samuel Ortiz" <samuel.ortiz@intel.com>
Subject: Re: [RFC PATCHv2 1/2] cfg80211/mac80211: Update set_tx_power to
	use mBm instead of dBm units
References: <1277116766-4764-1-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1277116766-4764-1-git-send-email-juuso.oikarinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Juuso Oikarinen" <juuso.oikarinen@nokia.com>:

> In preparation for a TX power setting interface in the nl80211, change the
> .set_tx_power function to use mBm units instead of dBm for greater  
> accuracy and
> smaller power levels.
>
> Also, already in advance move the tx_power_setting enumeration to nl80211.
>
> This change affects the .tx_set_power function prototype. As a result, the
> corresponding changes are needed to modules using it. These are mac80211,
> iwmc3200wifi and rndis_wlan.

rndis_wlan part:
Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

-Jussi

