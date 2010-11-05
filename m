Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab0KERyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 13:54:45 -0400
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: working usb wifi card, that is still possible to buy
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Fri, 05 Nov 2010 18:54:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: Josh Lehan <krellan@krellan.com>, Pavel Machek <pma@sysgo.com>,
	<linux-wireless@vger.kernel.org>
In-Reply-To: <4CD4036E.9090300@lwfinger.net>
References: <20101103092431.GA21138@pma.sysgo.com> <4CD3CDB1.2090508@krellan.com> <4CD4036E.9090300@lwfinger.net>
Message-ID: <ff5cf9bdd23aa256b379521d4c4263d8@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 05 Nov 2010 08:15:26 -0500, Larry Finger
> The Realtek RTL8712 (aka RTL8192U) and found in the D-Link DWA 130, has
a
> driver
> in 2.6.37 (r8712u). Although not based on mac80211, thus found in
staging,
> the
> driver is extremely stable - my connection never drops out. With an
802.11n
> router, I get transmission throughput of up to 70 Mb/s.

That definitely requires USB 2 though, and I suspect that
nobody actually ever tests their devices on a 1.1 only
controller like Pavel was asking for.

johannes
