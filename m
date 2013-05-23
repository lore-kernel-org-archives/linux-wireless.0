Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab3EWMYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 08:24:12 -0400
Message-ID: <1369311847.12002.3.camel@jlt4.sipsolutions.net> (sfid-20130523_142415_522966_22AE409A)
Subject: Re: [PATCH v2 1/3] mac80211: add STBC flag for radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Thu, 23 May 2013 14:24:07 +0200
In-Reply-To: <1369293475-9408-1-git-send-email-linux@rempel-privat.de> (sfid-20130523_091809_288612_15DDE804)
References: <1369250674.8207.26.camel@jlt4.sipsolutions.net>
	 <1369293475-9408-1-git-send-email-linux@rempel-privat.de>
	 (sfid-20130523_091809_288612_15DDE804)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-23 at 09:17 +0200, Oleksij Rempel wrote:
> revision:
> - v2. set HAVE_STBC only if it is present.
>       do not set STBC flag on TX packets.

Please don't include changes *inside* the changelog. Also, an actual
commit message would be nice.

johannes

