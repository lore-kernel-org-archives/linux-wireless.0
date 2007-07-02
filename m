Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49451 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566AbXGBNw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2007 09:52:58 -0400
Date: Mon, 2 Jul 2007 15:53:09 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: "Cohen, Guy" <guy.cohen@intel.com>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [WIP] mac80211: kill mgmt interface
Message-ID: <20070702155309.5300ef7f@griffin.suse.cz>
In-Reply-To: <394827.41199.qm@web51403.mail.re2.yahoo.com>
References: <394827.41199.qm@web51403.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Von: "Cohen, Guy" <guy.cohen@intel.com>
> > This is a required feature for Access Points (multiple BSSID).

On Mon, 2 Jul 2007 06:38:00 -0700 (PDT), Joerg Pommnitz wrote:
> And, just from reading the documentation, it seems to be supported by MadWifi for Atheros
> based devices:
> 
> http://madwifi.org/wiki/ngFeatures
> 
> and note the "To create APs which share a single MAC address, use the -bssid flag when
> creating the VAPs:"  remark.
> 
> Even if no current mac80211 driver supports this feature, the API must not prevent this in the future.

What are you talking about? Have you actually looked at mac80211? This
is supported from day 0 of d80211.

 Jiri

-- 
Jiri Benc
SUSE Labs
