Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49127 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3CSSau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 14:30:50 -0400
Received: by mail-wg0-f43.google.com with SMTP id e12so620412wge.34
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 11:30:49 -0700 (PDT)
Date: Tue, 19 Mar 2013 19:30:44 +0100
From: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	664767@bugs.debian.org, linux-wireless@vger.kernel.org
Subject: Re: Brcmsmac driver woes, possible regression?
Message-ID: <20130319183044.GA8058@stt008.linux.site> (sfid-20130319_193054_869948_E93C36D9)
References: <51476D25.6030609@broadcom.com> <20130318211428.GA9136@stt008.linux.site> <20130318212544.GB5062@elie.Belkin> <CAKprTDFXV4J7cxGqNck95Cu=ncBXCfdNTir40aWRtXjpLPO6OQ@mail.gmail.com> <CAKprTDEddPVp+bk7RJX1Jk60b0zVHr4ghvqt0HKnY+h238t3Zw@mail.gmail.com> <1363711989.2225.8.camel@dcbw.foobar.com> <20130319173054.GA7873@stt008.linux.site> <1363715961.2225.22.camel@dcbw.foobar.com> <20130319181135.GA7969@stt008.linux.site> <1363716980.2225.32.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363716980.2225.32.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 2013-03-19 a las 13:16 -0500, Dan Williams escribió:

> On Tue, 2013-03-19 at 19:11 +0100, Camaleón wrote:

(...)

> > > NM minimally verifies the PSK, which by 802.11 standards is between 8
> > > and 63 ASCII characters inclusive.  So you should be able to type
> > > anything you want within those constraints, but clearly only one is your
> > > real PSK.
> > 
> > Oops! Okay, so what user inputs is not "bullet-proof".
> > 
> > Anyway, this does not seem to be a problem of bad password. I was 
> > finally able to get connected to the AP as soon as I carry the nebook 
> > and put it next to the AP which is the problem I've always have had 
> > with this driver (brcmsmac).
> 
> Yeah, that's a symptom of bad power control or bad gain or who knows
> what in the driver.  But also, make sure your antennas are connected
> correctly :)

I'm starting to think the embedded wireless adapter could have been 
damaged somehow. The fact is that the card worked fine until kernel 2.6.38 
(IIRC), but afterwards... well, I had to connect an additional USB card.

> > As soon as I back to another room, N-M asks me again for the pass-key 
> > and disconnects.
> 
> NM 0.9.8 shouldn't do that; I bet you're not even getting to the point
> where the 4-way handshake and password verification are done.  NM 0.9.8
> will retry a few times, notify you and fail, then wait a couple minutes
> and try again.  It shouldn't ask for a password anymore in situations
> like this.

Debian Wheezy still has 0.9.4 but well, that's a minor issue ;-(

Greetings,

-- 
Camaleón 
