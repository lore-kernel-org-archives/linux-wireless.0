Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1JLIbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 04:31:39 -0400
Subject: Re: [RFC 05/07] mac80211: Purge cfg80211 beacon cache before
 authentication.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
In-Reply-To: <op.v27ruyliya27un@edmitar> (sfid-20111012_030254_860153_C3D1FBFD)
References: <op.v27ruyliya27un@edmitar>
	 (sfid-20111012_030254_860153_C3D1FBFD)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 10:31:36 +0200
Message-ID: <1318408296.3933.28.camel@jlt3.sipsolutions.net> (sfid-20111012_103148_274224_4EB0F58A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-12 at 03:02 +0200, Dmitry Tarnyagin wrote:
> From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
> Date: Wed, 10 Aug 2011 19:15:13 +0200
> 
> cw1200 device requires SSID to be available at AUTH stage.
> cfg80211 beacon cache is designed to handle multi-SSID BSSes, so
> bss struct returned by cfg80211_get_bss() has random SSID if BSS
> just changed SSID before authentication (typical for p2p).
> 
> As a workaround cfg80211 beacon cache is purged to make sure
> target BSS is searchable in rb-tree at the AUTH stage.

Funny, but hell no.

johannes

