Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62874 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2CRTTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2012 15:19:10 -0400
Received: by dajr28 with SMTP id r28so8819652daj.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Mar 2012 12:19:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332065984.3609.5.camel@jlt3.sipsolutions.net>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	<1331902885.6753.10.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	<1332065984.3609.5.camel@jlt3.sipsolutions.net>
Date: Sun, 18 Mar 2012 12:19:10 -0700
Message-ID: <CAJ-VmomNGku0CNfX+feeeUET4mXEFDj976sSfg-GG-KUSGCWvw@mail.gmail.com> (sfid-20120318_201915_501997_6CA13B3D)
Subject: Re: mac80211 20/40 coexist
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	"Manoharan, Sujith" <c_manoha@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 March 2012 03:19, Johannes Berg <johannes@sipsolutions.net> wrote:

> I'm not sure I can believe this -- surely the firmware has to have a way
> of dealing with stations that can't do 40 MHz and stations that can, so
> switching between the two doesn't seem like a major proposal? We also
> don't currently handle the action frames for that, but it seems like we
> should.
>
> Note, however, that we're now discussing something already done --
> Paul's patch already removed the channel type update when all we wanted
> was update the RC.

When are stations being notified of a CWM change?

I know FreeBSD handles it with a big stick at the moment - it just
does a full interface reset and channel change. I don't necessarily
like it, but I haven't yet sat down to look at when and why this is
occuring.


Adrian
