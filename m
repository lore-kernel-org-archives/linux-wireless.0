Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423662Ab2LFPC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 10:02:59 -0500
Message-ID: <1354806200.18211.1.camel@jlt4.sipsolutions.net> (sfid-20121206_160305_331576_60F5A9A7)
Subject: Re: Wireless network problem with Access Point selection using ifup
From: Johannes Berg <johannes@sipsolutions.net>
To: markh@compro.net
Cc: linux-wireless@vger.kernel.org, Mark Hounschell <dmarkh@cfl.rr.com>
Date: Thu, 06 Dec 2012 16:03:20 +0100
In-Reply-To: <50C0A743.3000305@compro.net> (sfid-20121206_152423_356618_ADE5D3BC)
References: <50C0A743.3000305@compro.net>
	 (sfid-20121206_152423_356618_ADE5D3BC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-06 at 09:10 -0500, Mark Hounschell wrote:
>  I'm using 
> traditional ifup with static configurations.

You should at least run wpa_supplicant, which will pick a better network
and reconnect if the connection drops etc. Almost no device does that by
itself any more.

johannes

