Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab0EKIxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 04:53:23 -0400
Subject: Re: [RFC PATCH 0/2] mac80211: antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	holgerschurig@gmail.com
In-Reply-To: <20100511083121.28289.96180.stgit@tt-desk>
References: <20100511083121.28289.96180.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 10:53:19 +0200
Message-ID: <1273567999.3669.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-11 at 17:38 +0900, Bruno Randolf wrote:

> i have followed holger schurig's suggestion to use a bitmap for allowed
> antennas. when multiple antennas are selected in the bitmap, the driver may use
> diversity. i think that this allows for the most flexible, yet simple
> configuration of antennas, and drivers can just reject configurations they
> cannot support. i hope that this will also be generic enough for 802.11n with
> multiple antennas

Not sure ... 11n has antennas and chains, but people mix them up
frequently. Does this API even make sense for 11n? Use cases? Should it
be about *antennas*, or about *chains*?

johannes

