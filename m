Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:60650 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbYIRTQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 15:16:46 -0400
To: Johannes Berg <johannes@sipsolutions.net>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
	linux-wireless@vger.kernel.org
Subject: Re: temorarily out of range -> no TCP?
In-reply-to: <1221762748.20772.7.camel@johannes.berg>
References: <20080918141955.0119E93CCA7@tippex.mynet.homeunix.org> (sfid-20080918_162007_153222_33378A12) <1221762748.20772.7.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 18 Sep 2008 21:16:33 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080918191633.C8BAB93CCA7@tippex.mynet.homeunix.org> (sfid-20080918_211649_003670_8B83923D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


johannes@sipsolutions.net said:
> Oh and that works just fine for me, I do it all the time. ssh can take a long
> time to recover though, for some reason, so I tend to kill it (I do
> everything in screen anyway). 

Hmmm, alright, I'll try to sit one out and see what happens. 

How do I best trigger an out of range condition? Power cycle the AP?

/Anders
PS I assume the IP stack signals the tcp queue that there is an operational 
and suitable link out of the machine when the driver is happy again, right?

Howcome I needs to rmmod/modprobe it?

