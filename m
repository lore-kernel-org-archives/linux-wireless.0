Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33438 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756124AbXD1NZK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 09:25:10 -0400
Date: Sat, 28 Apr 2007 15:25:05 +0200
From: Jiri Benc <jbenc@suse.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Message-ID: <20070428152505.5ed06505@logostar.upir.cz>
In-Reply-To: <4632614B.8060102@linux.intel.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	<20070423184814.7029.8413.stgit@magic.sourmilk.net>
	<4632614B.8060102@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Apr 2007 13:47:07 -0700, James Ketrenos wrote:
> [PATCH] Fix ieee80211_sta_config_auth to select networks if rssi < 0
> 
> The rssi check was against the top_rssi being less than the network
> rssi.  However, 0 is higher than all negative rssi, so if an adapter
> returned negative rssi values, auto AP selection would never work.
> 
> This patch changes behavior such if no network is currently selected it
> ignores the rssi comparison and picks the network that matches all other criteria.

Applied, thanks!

 Jiri

-- 
Jiri Benc
SUSE Labs
