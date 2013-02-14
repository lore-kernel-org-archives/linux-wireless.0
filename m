Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab3BNUWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 15:22:55 -0500
Message-ID: <1360873369.8210.17.camel@jlt4.sipsolutions.net> (sfid-20130214_212300_939096_BB2BD8D4)
Subject: Re: [PATCH 1/2] cfg80211: Pass station (extended) capability info
 to kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 21:22:49 +0100
In-Reply-To: <20130214191013.GA28969@jouni.qca.qualcomm.com>
References: <20130214191013.GA28969@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 21:10 +0200, Jouni Malinen wrote:
> The information of the peer's capabilities and extended capabilities are
> required for the driver to perform TDLS Peer UAPSD operations and off
> channel operations. This information of the peer is passed from user space
> using NL80211_CMD_SET_STATION command. This commit enhances
> the function nl80211_set_station to pass the capability information of
> the peer to the driver.
> 
> Similarly, there may be need for capability information for other modes,
> so allow this to be provided with both add_station and change_station.

Applied.

johannes

