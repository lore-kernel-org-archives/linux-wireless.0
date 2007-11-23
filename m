Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:15822 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbXKWNWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 08:22:52 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 regression: doesn't associate automatically
Date: Fri, 23 Nov 2007 14:23:23 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <200711221719.40412.hs4233@mail.mn-solutions.de> <1195821998.4149.113.camel@johannes.berg>
In-Reply-To: <1195821998.4149.113.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711231423.23910.hs4233@mail.mn-solutions.de> (sfid-20071123_132256_552469_40D633D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yes, but you're assuming "YYY" is a MAC address while in fact
> it can have two special meanings, "any" and "off", see the
> iwconfig man page.

Oh sorry, that was an oversight of me. Thanks for clarification.


> You understood: Johannes hates me, he thinks mac80211 is
> buggy, and he also thinks mac80211 should only do what he
> thinks wext defines.

Hate is too strong a word here :-)   I don't have feelings 
towards you (in person), but I perceiving you as one that is 
just "talking things away". And that is what I didn't liked, 
made me frustrated and shooting over the top.

Anyway, I want to drop that now.




Is my second sequence "which I dug out" also not a problem?

$ pccardctl insert
$ iwconfig eth1 key s:11111
$ iwconfig eth1 essid MUMBLEFUTZ
$ ifconfig eth1 up

This sequence is basically what Debian executes at "ifup eth1" 
time when no wpa_supplicant is used. And it doesn't lead to an 
association, not even to a scanning (according to iwevent) when 
used with mac80211/b43.

I hope that is a bug that is more difficult to talk away. :-)
