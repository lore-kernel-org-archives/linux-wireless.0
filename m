Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58312 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab2ENOHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 10:07:55 -0400
Message-ID: <1337004474.4303.17.camel@jlt3.sipsolutions.net> (sfid-20120514_160801_055005_D6DF6B40)
Subject: Re: iwlwifi regression: disconnections
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 14 May 2012 16:07:54 +0200
In-Reply-To: <CALGY4fvUmHmFbYAH2044qCBOozOqmOCBcmB8acV-Qivd3PpFgQ@mail.gmail.com> (sfid-20120514_160052_465054_559DF6AB)
References: <CALGY4fvUmHmFbYAH2044qCBOozOqmOCBcmB8acV-Qivd3PpFgQ@mail.gmail.com>
	 (sfid-20120514_160052_465054_559DF6AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-14 at 10:00 -0400, Nikolay Martynov wrote:

>   Here is what I see in logs during disconnect:
> 
> [ 1024.296004] ICMPv6 RA: ndisc_router_discovery() failed to add default route.
> [ 1259.209166] wlan1: deauthenticating from XX:XX:XX:XX:XX:XX by local
> choice (reason=3)

> I'll be happy to help with any additional information of debugging.

Hmm, this is interesting. Can you check syslog for anything from
wpa_supplicant and/or network manager or whatever you use? This just
means userspace decided to disconnect, but doesn't give a clue as to
why.

johannes

