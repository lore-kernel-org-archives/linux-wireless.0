Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:34793 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761736AbYDYWTo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2008 18:19:44 -0400
Subject: Re: rt61pci current wireless testing git gives kernel oops
From: Bas Hulsken <bhulsken@hotmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <200804252031.56605.IvDoorn@gmail.com>
References: <1209147056.2955.7.camel@Bas>
	 <200804252031.56605.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 00:15:22 +0200
Message-Id: <1209161722.6378.2.camel@Bas> (sfid-20080426_002008_845021_B6524D10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > the interface goes up well, but I get an oops as soon as I run hostapd,
> > seems something with debugfs. This shows up in dmesg, let me know if you
> > need any more info.
> 
> Johannes, this issue might have been introduced in your patch
> "[PATCH] mac80211: fix key vs. sta locking problems"
> do you know about this issue?

might be possible, I tried with
mac80211-v2.6.25_rc9_5745_g58908b9_080418-1 (wirelesstesting cheched out
at the 18th of April) when this patch was not yet committed, and the
oops does not occur. But then again, I don't get any traffic on the
monitoring interface with this version, so it might also just not get
triggered. 

Bas


