Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:37763 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXICXkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 19:40:46 -0400
Date: Mon, 3 Sep 2007 16:39:06 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: driver_devicescape: remove set_broadcast_ssid
Message-ID: <20070903233906.GR1835@jm.kir.nu>
References: <1188479812.2963.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188479812.2963.36.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 30, 2007 at 03:16:52PM +0200, Johannes Berg wrote:
> mac80211 doesn't have any drivers that care about this flag which
> is not really surprising: hostapd is responsible for this setting
> since it creates the beacon. Remove the callback.

Thanks! Applied.

-- 
Jouni Malinen                                            PGP id EFC895FA
