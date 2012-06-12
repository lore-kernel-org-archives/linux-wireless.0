Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2FLLIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 07:08:15 -0400
Message-ID: <1339499291.4531.1.camel@jlt3.sipsolutions.net> (sfid-20120612_130817_494450_4B418DC5)
Subject: Re: [PATCH] mac80211: Disallow changing chan type on monitor when
 CHAN_MODE_FIXED
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 12 Jun 2012 13:08:11 +0200
In-Reply-To: <1339499167-26225-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20120612_130639_458885_983B325C)
References: <1339499167-26225-1-git-send-email-pontus.fuchs@gmail.com>
	 (sfid-20120612_130639_458885_983B325C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 13:06 +0200, Pontus Fuchs wrote:
> If you add a monitor interface in paralell to a normal interface
> mac80211 will let you to change the channel type on the monitor
> interface even if you are connected. Add an explicit check to
> disallow this.

Is this against 3.5, and is it really needed there? It's a corner case
to start with.

johannes


