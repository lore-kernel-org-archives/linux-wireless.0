Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab0EKIvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 04:51:39 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	holgerschurig@gmail.com
In-Reply-To: <20100511083900.28289.43864.stgit@tt-desk>
References: <20100511083121.28289.96180.stgit@tt-desk>
	 <20100511083900.28289.43864.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 10:51:35 +0200
Message-ID: <1273567895.3669.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-11 at 17:39 +0900, Bruno Randolf wrote:
> Allow setting TX and RX antenna configuration via nl80211/cfg80211.
> 
> The antenna configuration is defined as a bitmap of allowed antennas. This
> bitmap is 8 bit at the moment, each bit representing one antenna. If multiple
> antennas are selected, the driver may use diversity for receive and transmit.
> This allows for a simple, yet flexible configuration interface for antennas,
> while drivers may reject configurations they cannot support.

This is missing advertising whether or not the commands are available.
Look for the CMD() macro.

johannes

