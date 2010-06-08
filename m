Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab0FHJFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 05:05:08 -0400
Subject: Re: [PATCH v3 1/3] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <201006081010.13314.br1@einfach.org>
References: <20100607065858.16060.38448.stgit@tt-desk>
	 <1275901514.3639.4.camel@jlt3.sipsolutions.net>
	 <201006081010.13314.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 11:05:02 +0200
Message-ID: <1275987902.3706.107.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-08 at 10:10 +0900, Bruno Randolf wrote:

> i don't particularly care about where the antenna information is printed 
> exactly, so anything will be fine with me.
> 
> but when i look at the wiphy info, it shows mostly capability information, 
> like the list of supported frequencies, list of bitrates, supported interface 
> modes, supported commands. the only exception is coverage class, which is the 
> only runtime configuration as far as i can see. therefore i thought it doesnt 
> fit there well.
> 
> maybe another command for getting runtime configuration like channel(s), fixed 
> bitrates, essid, bssid, RTS/CTS, fraqmentation, txpower, power management, 
> antenna settings, etc... would make sense? allthough in this list antenna is 
> probably the only one which is per phy and not per interface...

Right so there isn't much runtime stuff in the list now. I don't see
anything inherently bad in adding more though, since userspace can
selectively look at the attributes, and it's not like it's a huge amount
of data?

johannes

