Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab0G0KFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 06:05:45 -0400
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com
In-Reply-To: <20100727094759.27186.79639.stgit@tt-desk>
References: <20100727094732.27186.30900.stgit@tt-desk>
	 <20100727094759.27186.79639.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 12:05:42 +0200
Message-ID: <1280225142.19098.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-07-27 at 18:48 +0900, Bruno Randolf wrote:

> The antenna configuration is defined as a bitmap of allowed antennas to use for
> either receiving or transmitting. Separate bitmaps are used for RX and TX to
> allow configuring different antennas for receiving and transmitting. The bitmap
> is 8 bit long, each bit representing one antenna, starting with antenna 1.
> 
> If multiple receive (RX) antennas are selected, the driver may use diversity or
> multiple 802.11n RX chains, according to the chipset capabilities and
> configuration.

I'm still not convinced that this is the best approach. Can you discuss
this a bit?

johannes

