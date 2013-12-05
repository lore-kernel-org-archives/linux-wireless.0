Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm18.bullet.mail.ird.yahoo.com ([77.238.189.71]:41061 "HELO
	nm18.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752671Ab3LEQUF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 11:20:05 -0500
References: <1386259047.2121.YahooMailNeo@web172705.mail.ir2.yahoo.com>	 (sfid-20131205_165733_059424_F6F2D350) <1386259875.4182.15.camel@jlt4.sipsolutions.net>
Message-ID: <1386260074.45953.YahooMailNeo@web172706.mail.ir2.yahoo.com> (sfid-20131205_172010_974853_013DDEAF)
Date: Thu, 5 Dec 2013 16:14:34 +0000 (GMT)
From: Dani Camps <danicamps81@yahoo.com>
Reply-To: Dani Camps <danicamps81@yahoo.com>
Subject: Re: Using wmediumd in kernel 3.10
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1386259875.4182.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Hi,

I am only loading mac80211_hwsim with the parameter "radios=2". I am not specifying anything about "channels", which looking at the code should be 1.

Cheers

Daniel



El Jueves 5 de diciembre de 2013 17:11, Johannes Berg <johannes@sipsolutions.net> escribió:


> I would like to use wmediumd with linuxwireless backports 3.10.
> 
> The problem is that as indicated in this
> post: http://www.spinics.net/lists/linux-wireless/msg96575.html,
> wmediumd is not supported in this kernel. Quoting from the post:
> 
> "To use mac80211_hwsim for testing channel contexts it has to support
> them, and for that it has to support hw scan and hw-remain-on-channel.
> Since it's pure software, the off-channel activities are really not
> off-channel but listening and sending on a second channel. Also, the
> multi-channel isn't really doing TDM, it's just on both channels at
> the same time. 
> Note that this breaks wmediumd right now as it doesn't propagate the
> channel."

This should only affect hwsim if you load it with channels=2 or more,
are you doing that?

johannes
