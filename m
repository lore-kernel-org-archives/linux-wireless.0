Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab3BNUXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 15:23:17 -0500
Message-ID: <1360873393.8210.18.camel@jlt4.sipsolutions.net> (sfid-20130214_212319_398866_7F0A12EF)
Subject: Re: [PATCH 2/2] cfg80211: Pass TDLS peer's QoS/HT/VHT information
 during set_station
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 21:23:13 +0100
In-Reply-To: <20130214191054.GA29004@jouni.qca.qualcomm.com>
References: <20130214191054.GA29004@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 21:10 +0200, Jouni Malinen wrote:
> The information of the peer's capabilities is required for the driver
> to perform TDLS Peer UAPSD operations. This information of the peer is
> passed by the supplicant using NL80211_CMD_SET_STATION command. This
> commit enhances the function nl80211_set_station to pass this
> information of the peer to the driver in case this command is used
> with the TDLS peer STA.
> 
> In addition, make the HT/VHT capability configuration handled more
> consistently for other STA cases (reject both instead of just HT).

Applied.

johannes

