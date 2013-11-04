Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35496 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3KDQE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 11:04:29 -0500
Message-ID: <1383581060.14295.16.camel@jlt4.sipsolutions.net> (sfid-20131104_170432_762944_3D7F748A)
Subject: Re: r92su: status and will it be merged anytime soon?
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	alexandre.f.demers@gmail.com, linville@tuxdriver.com
Date: Mon, 04 Nov 2013 17:04:20 +0100
In-Reply-To: <2241712.PWvD8zsTbX@blech> (sfid-20131104_164804_181538_4F8FA020)
References: <5277AC85.5050104@gmail.com> <5277BE84.7020808@lwfinger.net>
	 <2241712.PWvD8zsTbX@blech> (sfid-20131104_164804_181538_4F8FA020)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-04 at 16:47 +0100, Christian Lamparter wrote:

> Be careful ;-). mac80211 is great for softmac/umac/halfmac/semimac devices.
> However the rtl8712 firmware interface is fullmac-like, so it needs cfg80211.
> ... and r92su uses cfg80211 exclusively. There's no more WEXT or realtek ioctl
> legacy API support.

still seems there's duplicate stuff in there like the michael MIC, at
least lib80211 has that? OTOH, that's not all that much code.

johannes

