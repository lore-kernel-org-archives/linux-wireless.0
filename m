Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab2GEO1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 10:27:34 -0400
Message-ID: <1341498452.4455.44.camel@jlt3.sipsolutions.net> (sfid-20120705_162738_484043_D64A640C)
Subject: Re: SIOCSIFFLAGS: operation not supported error message when
 tryinging to bring up an interface in adhoc mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Philippe Agostini <philippe.agostini@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Jul 2012 16:27:32 +0200
In-Reply-To: <CADnjpYvb15WvfZVnSpNvUiUAEdUgntOS2yoCyfxDZqHu+JBA5Q@mail.gmail.com> (sfid-20120705_162557_048014_F2AC6601)
References: <CADnjpYvb15WvfZVnSpNvUiUAEdUgntOS2yoCyfxDZqHu+JBA5Q@mail.gmail.com>
	 (sfid-20120705_162557_048014_F2AC6601)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-05 at 16:25 +0200, Philippe Agostini wrote:
> Hello,
> 
> I am currently developing a wifi driver and I am having trouble with
> the adhoc mode. I am developing on Ubuntu 10.04 with kernel 2.6.32. To
> verify that my initialization is correct, I try to bring up and
> configure virtual interfaces. It's working in managed mode, but when I
> try an "ifconfig wlan0 up" in adhoc mode I get the following error
> message: "SIOCSIFFLAGS: operation not supported". At first I thought
> that it was because of the regulatory domain, but I defined only one
> supported channel (channel 6, F=2437 MHz) and it seems to me that iw
> reg get tells me that on this frequency I am allowed to set up
> wireless device in adhoc mode (country 00: (2402 - 2472 @ 40), (3, 20)
> and no flags following).
> 
> Are there mandatory flags to set up (besides wiphy->interface_modes =
> BIT(NL80211_IFTYPE_ADHOC)) that I missed, or callbacks to define in
> order to have a working adhoc interface ?

This would be a lot easier if you'd post your code :-)

johannes

