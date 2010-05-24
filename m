Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:16102 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab0EXTe0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 15:34:26 -0400
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
From: reinette chatre <reinette.chatre@intel.com>
To: "Christian P. Schmidt" <schmidt@digadd.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4BF795EB.9070902@digadd.de>
References: <4BF795EB.9070902@digadd.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 12:34:25 -0700
Message-ID: <1274729665.2091.15280.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-05-22 at 01:29 -0700, Christian P. Schmidt wrote:
> However, even with the new card, I could not make any kernel from 2.6.32
> to 2.6.34 connect to any of my access points. Those are a Telekom DSL
> router and a Juniper NetScreen 5GT Wireless. I tried WEP64, WPA, WPA2,
> and even no encryption at all. My laptop with an Intel WiFi Link 5300
> has no problems whatsoever in any of the modes.

Could you please post some logs captured during your association
attempts? Were there any errors in your logs? In addition to this,
having mac80211 verbose debugging enabled will help and also
wpa_supplicant logs. That will give us a place to start.

Reinette


