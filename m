Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60986 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbcBBPFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 10:05:32 -0500
Message-ID: <1454425529.2926.5.camel@sipsolutions.net> (sfid-20160202_160536_131288_CDCF5DB4)
Subject: Re: [PATCH v3] mac80211: Parse legacy and HT rate in injected frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@narfation.org>, linux-wireless@vger.kernel.org
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Date: Tue, 02 Feb 2016 16:05:29 +0100
In-Reply-To: <1453824673-12379-1-git-send-email-sven@narfation.org>
References: <1453824673-12379-1-git-send-email-sven@narfation.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-26 at 17:11 +0100, Sven Eckelmann wrote:
> Drivers/devices without their own rate control algorithm can get the
> information what rates they should use from either the radiotap
> header of
> injected frames or from the rate control algorithm. But the parsing
> of the
> legacy rate information from the radiotap header was removed in
> commit
> e6a9854b05c1 ("mac80211/drivers: rewrite the rate control API").
> 
Applied.

johannes
