Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32859 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965845AbaLLLTY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 06:19:24 -0500
Message-ID: <1418383161.2470.12.camel@sipsolutions.net> (sfid-20141212_121927_491262_66C7DCCB)
Subject: Re: [PATCH] cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz
 drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Dec 2014 12:19:21 +0100
In-Reply-To: <20141211214855.GA9826@jouni.qca.qualcomm.com>
References: <20141211214855.GA9826@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-12-11 at 23:48 +0200, Jouni Malinen wrote:
> The VHT supported channel width field is a two bit integer, not a
> bitfield. cfg80211_chandef_usable() was interpreting it incorrectly and
> ended up rejecting 160 MHz channel width if the driver indicated support
> for both 160 and 80+80 MHz channels.

Applied, thanks.

johannes

