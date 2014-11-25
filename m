Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50711 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbaKYMID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 07:08:03 -0500
Message-ID: <1416917279.2045.5.camel@sipsolutions.net> (sfid-20141125_130812_715568_13EC1C7A)
Subject: Re: [PATCH] mac80211: check if channels allow 80 MHz for VHT probe
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: YanBo <dreamfly281@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 25 Nov 2014 13:07:59 +0100
In-Reply-To: <CAFuUQkhuUDVcfv-pxLkhNT7C2TOqOS4nh+3qDj0uFV3OpoAS5w@mail.gmail.com> (sfid-20141125_121045_823254_292A54E3)
References: <1416911009-22405-1-git-send-email-johannes@sipsolutions.net>
	 <CAFuUQkh-fX3rz9+FUBfF8GxbkxrZxP7-iJwmypo5EEANwODqzQ@mail.gmail.com>
	 <1416913453.2045.4.camel@sipsolutions.net>
	 <CAFuUQkhuUDVcfv-pxLkhNT7C2TOqOS4nh+3qDj0uFV3OpoAS5w@mail.gmail.com>
	 (sfid-20141125_121045_823254_292A54E3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-25 at 19:10 +0800, YanBo wrote:

> We already start the working to support the VHT modulations MCS8 and
> MCS9 support in 2.4G for ath10k  devices,
> and it used the band->vht_cap = vht_cap to notification the mac80211,
> if we band it with 80MHz, it is do need another
> new advertisement for this as your said.

But is all of that really the right way? I'm not completely convinced.

I guess we can make this check conditional for 5GHz when the VHT support
lands and is discussed.

johannes

