Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab0H3HrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 03:47:10 -0400
Subject: Re: [PATCH] mac80211: Add DS Parameter Set into Probe Request on
 2.4 GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100828163751.GB23426@jm.kir.nu>
References: <20100828163751.GB23426@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 09:47:04 +0200
Message-ID: <1283154424.3691.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-08-28 at 19:37 +0300, Jouni Malinen wrote:
> IEEE Std 802.11k-2008 added DS Parameter Set information element into
> Probe Request frames as an optional information on 2.4 GHz band (and
> mandatory, if radio measurements are enabled). This allows APs to
> filter out Probe Request frames that may be received from neighboring
> overlapping channels and by doing so, reduce the number of unnecessary
> frames in the air. Make mac80211 add this IE into Probe Request frames
> whenever the channel is known (i.e., whenever hwscan is not used).

Nice.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

