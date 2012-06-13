Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2FMIXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 04:23:53 -0400
Message-ID: <1339575830.4519.15.camel@jlt3.sipsolutions.net> (sfid-20120613_102357_224275_E7F3A19A)
Subject: Re: [PATCH v2] mac80211: Disallow changing chan type on monitor
 when CHAN_MODE_FIXED
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 13 Jun 2012 10:23:50 +0200
In-Reply-To: <1339503199-1237-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20120612_141331_317067_6BBF1A2C)
References: <1339503199-1237-1-git-send-email-pontus.fuchs@gmail.com>
	 (sfid-20120612_141331_317067_6BBF1A2C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 14:13 +0200, Pontus Fuchs wrote:
> If you add a monitor interface in paralell to a normal interface
> mac80211 will let you to change the channel type on the monitor
> interface even if you are connected. Add an explicit check to
> disallow this.

Applied, I fixed the typo (parallel) and replaced !netdev with !sdata to
match the other line of code.

johannes


