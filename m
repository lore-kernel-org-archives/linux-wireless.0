Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:33935 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423Ab3CSSLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 14:11:41 -0400
Received: by mail-we0-f180.google.com with SMTP id k14so635297wer.39
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 11:11:39 -0700 (PDT)
Date: Tue, 19 Mar 2013 19:11:35 +0100
From: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	664767@bugs.debian.org, linux-wireless@vger.kernel.org
Subject: Re: Brcmsmac driver woes, possible regression?
Message-ID: <20130319181135.GA7969@stt008.linux.site> (sfid-20130319_191145_397597_9031FA7B)
References: <CAKprTDFhNnGOPHUqg8Wn6Cd170KaeXj7-w-D6wS2Cc38vstt5A@mail.gmail.com> <20130318083752.GA6570@elie.Belkin> <51476D25.6030609@broadcom.com> <20130318211428.GA9136@stt008.linux.site> <20130318212544.GB5062@elie.Belkin> <CAKprTDFXV4J7cxGqNck95Cu=ncBXCfdNTir40aWRtXjpLPO6OQ@mail.gmail.com> <CAKprTDEddPVp+bk7RJX1Jk60b0zVHr4ghvqt0HKnY+h238t3Zw@mail.gmail.com> <1363711989.2225.8.camel@dcbw.foobar.com> <20130319173054.GA7873@stt008.linux.site> <1363715961.2225.22.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363715961.2225.22.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 2013-03-19 a las 12:59 -0500, Dan Williams escribió:

> On Tue, 2013-03-19 at 18:30 +0100, Camaleón wrote:
> > El 2013-03-19 a las 11:53 -0500, Dan Williams escribió:
> > > 
> > > Note that NM 0.9.8 won't ask for a password when just anything fails,
> > > but will ask for a password if the 4-way handshake fails, because if
> > > that fails, it's probably your password.  We're contemplating getting
> > > rid of that too, and just notifying the user that their password may be
> > > wrong and that they should go update it in the network configuration
> > > panel so we don't interrupt.  But if you're 100% sure your PSK is
> > > correct, then it is, most likely, a driver bug.
> > 
> > Password is correct. I have a second wireless card (external, using 
> > rt2800usb driver) that connects without a glitch to the same AP.
> > 
> > Moreover, unless I type the right password, N-M dialog does not allow 
> > me to click on the "Connect" button.
> 
> NM minimally verifies the PSK, which by 802.11 standards is between 8
> and 63 ASCII characters inclusive.  So you should be able to type
> anything you want within those constraints, but clearly only one is your
> real PSK.

Oops! Okay, so what user inputs is not "bullet-proof".

Anyway, this does not seem to be a problem of bad password. I was 
finally able to get connected to the AP as soon as I carry the nebook 
and put it next to the AP which is the problem I've always have had 
with this driver (brcmsmac).

As soon as I back to another room, N-M asks me again for the pass-key 
and disconnects.

Greetings,

-- 
Camaleón 
