Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:44309 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbXIDA3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 20:29:38 -0400
Date: Mon, 3 Sep 2007 17:27:58 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: remove key threshold setting
Message-ID: <20070904002758.GW1835@jm.kir.nu>
References: <1187957890.24933.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187957890.24933.24.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 24, 2007 at 02:18:10PM +0200, Johannes Berg wrote:
> I'm in the process of adding this to nl80211 as a per-key setting, so
> remove it here for now. It's never called anyway.

Thanks, applied.

-- 
Jouni Malinen                                            PGP id EFC895FA
