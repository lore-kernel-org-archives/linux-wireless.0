Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42765 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750756AbZCXVIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 17:08:43 -0400
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Tue, 24 Mar 2009 22:08:40 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <c03d7e680903241348x27363902m764c25a9a439d419@mail.gmail.com>
Message-ID: <20090324210840.282530@gmx.net> (sfid-20090324_220846_550512_9CA840A6)
MIME-Version: 1.0
References: <c03d7e680903240959s51aa4864uaad281bd7487e823@mail.gmail.com>	
 <871vsmrekh.fsf@litku.valot.fi>
 <c03d7e680903241348x27363902m764c25a9a439d419@mail.gmail.com>
Subject: Re: Adhoc-demo support in mac80211
To: ming li <mingli@cs.umass.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ming!

> The good thing of adhoc-demo is that it does
> not have the beaconing overhead or=20

I personally don't like the idea implementing this non-standard mode in=
 mac80211 as a separate mode, but maybe allow the user to disable beaco=
ning with a nl80211 call?

Johannes, what do you think about it?

> the IBSS merging/splitting problem.

With mac80211 you can set a fixed BSSID like with madwifi to solve this=
 Problem.

iwconfig wlan0 ap 42:ca:ff:ee:fe:ed

Regards
Alina

--=20
Aufgepasst: Sind Ihre Daten beim Online-Banking auch optimal gesch=FCtz=
t?
Jetzt absichern: https://homebanking.gmx.net/?mc=3Dmail@footer.hb
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
