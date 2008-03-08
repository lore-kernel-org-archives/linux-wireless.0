Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:34745 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343AbYCHLFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Mar 2008 06:05:22 -0500
To: "Tomas Winkler" <tomasw@gmail.com>
cc: "Helge Hafting" <helge.hafting@aitel.hist.no>,
	linux-wireless@vger.kernel.org
Subject: Re: iwl3945 associated and _worked_ with a *wrong* essid! 
In-reply-to: <1ba2fa240803050749j8bb291ajb8a0451504a0b905@mail.gmail.com> 
References: <47CE8ED6.7030302@aitel.hist.no> <1ba2fa240803050749j8bb291ajb8a0451504a0b905@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sat, 08 Mar 2008 11:38:30 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080308103831.0CBFE93C070@tippex.mynet.homeunix.org> (sfid-20080308_110525_811177_960F1B86)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I recently wrote about my iwl3945 problems - I usually
>  have to try 20-50 times before I can use a wep-encrypted access point.
>  Once the link goes up - no more problems. But getting the first
>  connection takes time.

I can testify that I have the same issue with w2k. I'm not sure how intel 
wired up their drivers package, but I usually have to wait about 1-2 minutes 
to get _any_ package back from the AP (judging from the network icon). Once I 
get the first package back (I'd guess it's a dhcp resp), i can start using the 
network.

I once picked up somehwere that this wa an issue with wither this intel chip 
of the broadcom chip I have in the Linksys AP. Either one of them was picky 
on the nitial handshake and the speed/rate used for that handshake. Waiting a 
while both ends agree to do it at 1Mbps or something and it all works from 
there.

hth,
/Anders

