Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7314 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757560AbYFZTTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 15:19:48 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>, cs010101@gmail.com,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200806261821.31643.mb@bu3sch.de>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <69e28c910806260846s3b02cdddlca3ac138acadd8bd@mail.gmail.com>
	 <1214496086.30722.14.camel@dv>  <200806261821.31643.mb@bu3sch.de>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 12:34:31 -0400
Message-Id: <1214498071.30722.22.camel@dv> (sfid-20080626_212018_263098_DED4301E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-26 at 18:21 +0200, Michael Buesch wrote:
> +	  ===> BIG FAT WARNING <===
> +	  This is not IEEE 802.11 compliant, yet!
> +	  You might disturb operation of other accesspoints and
> +	  stations in your neighbourhood. Do only enable this, if
> +	  you want to help out fixing this to make this warning disappear.
> +	  If you enable this, expect that your neighbour will ring your
> +	  door and yell at you for disturbing his network.

Gladly there will be no black helicopters :-)

But is it really so bad?  What's the current TODO list for the AP mode?
Is it an issue with 802.11h?  Maybe we could limit Tx power and channels
until the remaining issues are fixed?

Also, I think that the 802.11 simulator should be exempt from any
limitations for obvious reasons.

-- 
Regards,
Pavel Roskin
