Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48246 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbbHMNH4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 09:07:56 -0400
Message-ID: <1439471273.2114.28.camel@sipsolutions.net> (sfid-20150813_150808_577672_E689E8D8)
Subject: Re: [PATCH 0/4] mac80211: define VHT rate mask logic
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 13 Aug 2015 15:07:53 +0200
In-Reply-To: <1438897653-4629-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150806_234736_788238_1A139949)
References: <1438897653-4629-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20150806_234736_788238_1A139949)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-08-06 at 23:47 +0200, Lorenzo Bianconi wrote:
> Add support to mask vht rates using ratemask configured by the user 
> through
> iw command (e.g. iw dev wlan0 set bitrates vht-mcs-5 2:2,4).
> Remove ieee80211_tx_rate dependency in rate mask code in order to use
> mcs/legacy rate mask logic for station rate table as well.
> This patchset has been tested using mac80211/mt76 driver on
> Buffalo WHR-1166D router running OpenWrt trunk
> 

All four applied.

johannes
