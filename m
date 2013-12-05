Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52582 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3LEQLS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 11:11:18 -0500
Message-ID: <1386259875.4182.15.camel@jlt4.sipsolutions.net> (sfid-20131205_171122_325773_5C12C9DB)
Subject: Re: Using wmediumd in kernel 3.10
From: Johannes Berg <johannes@sipsolutions.net>
To: Dani Camps <danicamps81@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 05 Dec 2013 17:11:15 +0100
In-Reply-To: <1386259047.2121.YahooMailNeo@web172705.mail.ir2.yahoo.com> (sfid-20131205_165733_059424_F6F2D350)
References: <1386259047.2121.YahooMailNeo@web172705.mail.ir2.yahoo.com>
	 (sfid-20131205_165733_059424_F6F2D350)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


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

