Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38317 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAONic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:38:32 -0500
Message-ID: <1389793102.4338.14.camel@jlt4.sipsolutions.net> (sfid-20140115_143835_213827_D3860889)
Subject: Re: [PATCH 2/3] cfg80211: Advertise maximum associated STAs in AP
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Jan 2014 14:38:22 +0100
In-Reply-To: <20140114220108.GA19688@w1.fi>
References: <20140114220108.GA19688@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 00:01 +0200, Jouni Malinen wrote:
> This allows drivers to advertise the maximum number of associated
> stations they support in AP mode (including P2P GO). User space
> applications can use this for cleaner way of handling the limit (e.g.,
> hostapd rejecting IEEE 802.11 authentication without manual
> configuration of the limit) or to figure out what type of use cases can
> be executed with multiple devices before trying and failing.

Applied.

johannes

