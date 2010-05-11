Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0EKSTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 14:19:32 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, holgerschurig@gmail.com
In-Reply-To: <AANLkTilowwAyqLrIJ0_mlZxnqY-TqSHM3xdXkbO8aH6-@mail.gmail.com>
References: <20100511083121.28289.96180.stgit@tt-desk>
	 <20100511083900.28289.43864.stgit@tt-desk>
	 <AANLkTilowwAyqLrIJ0_mlZxnqY-TqSHM3xdXkbO8aH6-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 20:19:29 +0200
Message-ID: <1273601969.20312.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-11 at 11:14 -0700, Luis R. Rodriguez wrote:

> > Allow setting TX and RX antenna configuration via nl80211/cfg80211.
> 
> I think we should call this TX / RX chainmask given that with 802.11n
> hardware this is what this is called.

Well, but even with 11n hw you might be able to select _antennas_ rather
than chains. I'm convinced we'll need to differentiate that very
closely, and 11g hw has only antenna, not chain, selection.

johannes

