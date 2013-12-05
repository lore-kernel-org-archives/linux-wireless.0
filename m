Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3LEQZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 11:25:50 -0500
Message-ID: <1386260744.4182.18.camel@jlt4.sipsolutions.net> (sfid-20131205_172553_398539_8618263B)
Subject: Re: Using wmediumd in kernel 3.10
From: Johannes Berg <johannes@sipsolutions.net>
To: Dani Camps <danicamps81@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 05 Dec 2013 17:25:44 +0100
In-Reply-To: <1386260074.45953.YahooMailNeo@web172706.mail.ir2.yahoo.com>
References: <1386259047.2121.YahooMailNeo@web172705.mail.ir2.yahoo.com>
		 (sfid-20131205_165733_059424_F6F2D350) <1386259875.4182.15.camel@jlt4.sipsolutions.net>
	 <1386260074.45953.YahooMailNeo@web172706.mail.ir2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 16:14 +0000, Dani Camps wrote:

> I am only loading mac80211_hwsim with the parameter "radios=2". I am
> not specifying anything about "channels", which looking at the code
> should be 1.

Ok. What's the easiest way to reproduce this? Do I need
hostapd/wpa_supplicant and wmediumd, or something else?

johannes

