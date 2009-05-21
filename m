Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703AbZEUDUr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 23:20:47 -0400
Subject: Re: [PATCH 2/2] iwmc3200wifi: Add new Intel Wireless Multicomm
 802.11 	driver
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>
In-Reply-To: <43e72e890905201954x7a5bc41etf0305b793cbc032e@mail.gmail.com>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <1242872340-27417-2-git-send-email-yi.zhu@intel.com>
	 <1242872340-27417-3-git-send-email-yi.zhu@intel.com>
	 <43e72e890905201954x7a5bc41etf0305b793cbc032e@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 11:13:14 +0800
Message-Id: <1242875594.24825.605.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-21 at 10:54 +0800, Luis R. Rodriguez wrote:
> CHAN2G() and CHAN5G() could use the second argument removed, its
> always 0.

Yeah, I saw mac80211_hwsim doing this, but not ath9k ;-)

> BTW does 'iw list' give you something back with all these channels?

Yes. And we refresh the channel flags according to EEPROM afterwards.
Below is a paste of the 'iw list' result here. BTW, I'm using the
default world regdom.

Thanks,
-yi

---

Wiphy phy1
	Band 1:
		Frequencies:
			* 2412 MHz [1] (27.0 dBm)
			* 2417 MHz [2] (27.0 dBm)
			* 2422 MHz [3] (27.0 dBm)
			* 2427 MHz [4] (27.0 dBm)
			* 2432 MHz [5] (27.0 dBm)
			* 2437 MHz [6] (27.0 dBm)
			* 2442 MHz [7] (27.0 dBm)
			* 2447 MHz [8] (27.0 dBm)
			* 2452 MHz [9] (27.0 dBm)
			* 2457 MHz [10] (27.0 dBm)
			* 2462 MHz [11] (27.0 dBm)
			* 2467 MHz [12] (disabled)
			* 2472 MHz [13] (disabled)
			* 2484 MHz [14] (disabled)
		Bitrates:
			* 1.0 Mbps
			* 2.0 Mbps
			* 5.5 Mbps
			* 11.0 Mbps
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	Band 2:
		Frequencies:
			* 5170 MHz [34] (disabled)
			* 5180 MHz [36] (23.0 dBm) (no IBSS)
			* 5190 MHz [38] (disabled)
			* 5200 MHz [40] (23.0 dBm) (no IBSS)
			* 5210 MHz [42] (disabled)
			* 5220 MHz [44] (23.0 dBm) (no IBSS)
			* 5230 MHz [46] (disabled)
			* 5240 MHz [48] (23.0 dBm) (no IBSS)
			* 5260 MHz [52] (23.0 dBm) (no IBSS)
			* 5280 MHz [56] (23.0 dBm) (no IBSS)
			* 5300 MHz [60] (23.0 dBm) (no IBSS)
			* 5320 MHz [64] (23.0 dBm) (no IBSS)
			* 5500 MHz [100] (disabled)
			* 5520 MHz [104] (disabled)
			* 5540 MHz [108] (disabled)
			* 5560 MHz [112] (disabled)
			* 5580 MHz [116] (disabled)
			* 5600 MHz [120] (disabled)
			* 5620 MHz [124] (disabled)
			* 5640 MHz [128] (disabled)
			* 5660 MHz [132] (disabled)
			* 5680 MHz [136] (disabled)
			* 5700 MHz [140] (disabled)
			* 5745 MHz [149] (30.0 dBm) (no IBSS)
			* 5765 MHz [153] (30.0 dBm) (no IBSS)
			* 5785 MHz [157] (30.0 dBm) (no IBSS)
			* 5805 MHz [161] (30.0 dBm) (no IBSS)
			* 5825 MHz [165] (30.0 dBm) (no IBSS)
			* 5920 MHz [184] (disabled)
			* 5940 MHz [188] (disabled)
			* 5960 MHz [192] (disabled)
			* 5980 MHz [196] (disabled)
			* 6000 MHz [200] (disabled)
			* 6020 MHz [204] (disabled)
			* 6040 MHz [208] (disabled)
			* 6060 MHz [212] (disabled)
			* 6080 MHz [216] (disabled)
		Bitrates:
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	max # scan SSIDs: 10
	Supported interface modes:
		 * IBSS
		 * Station


