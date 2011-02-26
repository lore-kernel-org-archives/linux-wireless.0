Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49230 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab1BZKRO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 05:17:14 -0500
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] at76c50x-usb: fix warning caused by at76_mac80211_tx now returning void
References: <1298666834.4329.20.camel@jlt3.sipsolutions.net>
	<1298671436-2052-1-git-send-email-linville@tuxdriver.com>
	<1298712078.3922.0.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 26 Feb 2011 12:17:12 +0200
In-Reply-To: <1298712078.3922.0.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Sat\, 26 Feb 2011 10\:21\:18 +0100")
Message-ID: <87vd073xsn.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> v2 drop the frame and return...duh!
>> 
>> Will this hack still work if we drop the frame?  Did it ever work?
>
> I'm not sure it ever worked, Kalle did mention that this driver never
> really worked well.

The driver did work until mac80211 stopped providing ssid. The
firmware really needs the ssid before assocation, or at least I
haven't a way to workaround that.

I'm thinking of removing the driver altogether, as it's obvious that I
don't have time to work on it. If someone wants to volunteer to fix
it, now is the perfect time to do it :)

-- 
Kalle Valo
