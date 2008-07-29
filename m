Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:53875 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbYG2DPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 23:15:55 -0400
Message-ID: <488E8B68.6000004@lwfinger.net> (sfid-20080729_051558_312799_D78645BF)
Date: Mon, 28 Jul 2008 22:15:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
 rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>	 <200807221613.34434.herton@mandriva.com.br>	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>	 <200807221940.20009.herton@mandriva.com.br>	 <4886AA3B.3000406@lwfinger.net> <4886C50E.6040304@lwfinger.net>	 <1216824917.13587.9.camel@johannes.berg>	 <48874F09.7060400@lwfinger.net> <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
In-Reply-To: <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> Hi Larry, please tidy the tx seq no patch up and submit to wireless-testing..
> I think it is more appropriate to copy the actual comments in rt2000
> from Johannes?
> instead of or in addtion to: "XXX: This sequence is an attempt to
> match what happens in r2x00"
> 
> ... and feel free to add ack-by/tested-by me.
> 
> I am wondering about Herton's problem with power saving (which I had
> reproduced).
> I think one way to move forward is to enable MAC80211_PS_DEBUG(?) and
> see what happens
> to the tx queues, now that we have a reliable way of reproducing the problem.
> 
> I also wonder how Herton encountered the problem :-). Older
> wireless-testing simply
> say "unimplemented" or something if one tries to set power-saving.
> Maybe Herton has
> a few devices which he routinely tries out every part of iwconfig?

I sent that patch on July 24, or at least I thought I did. I was quite surprised 
to not find it in the wireless archives. In any case, I have sent it again tonight.

I tried Herton's sequence of steps for cennecting and it failed no matter what I 
did. In my case, only NetworkManager can get a connection.

I'm not sure how to proceed; however, if you can produce the problem reliably, 
then you have an edge.

Larry
