Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:52278 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYKALtG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 07:49:06 -0400
Date: Sat, 1 Nov 2008 13:47:54 +0200
From: Jouni Malinen <j@w1.fi>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Allow AP mode to be enabled
Message-ID: <20081101114754.GY3923@jm.kir.nu> (sfid-20081101_124912_071771_FD703B38)
References: <20081030175030.GD3923@jm.kir.nu> <878ws3ptrh.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <878ws3ptrh.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 01, 2008 at 01:31:30PM +0200, Kalle Valo wrote:

> I tried to test this with latest hostapd (commit b6a55236) and
> wireless-testing (commit d80fe0040), but unfortunately I wasn't
> succesful. Here's the output from hostapd with b43:

> ioctl[SIOCSIWESSID]: Operation not supported
> len=4
> Could not set SSID for kernel driver

Thanks for reporting this. I fixed it now in hostap.git. Johannes
removed SSID configuration from AP mode and I was just waiting for this
to hit wireless-testing before committing the change into hostapd.

-- 
Jouni Malinen                                            PGP id EFC895FA
