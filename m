Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35797 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZAKE6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 23:58:50 -0500
Subject: Re: Help debugging unexpected disassociations?
From: Ari Entlich <lmage11@twcny.rr.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890901100516mc2e1ee1h42c4f67b552f7d73@mail.gmail.com>
References: <20090110021351.MHLV4.64591.root@hrndva-web24-z02>
	 <3ace41890901100516mc2e1ee1h42c4f67b552f7d73@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 23:58:46 -0500
Message-Id: <1231649926.21931.5.camel@g4mdd.entnet> (sfid-20090111_055853_066625_95CBB434)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-01-10 at 13:16 +0000, Hin-Tak Leung wrote:
> On Sat, Jan 10, 2009 at 2:13 AM,  <lmage11@twcny.rr.com> wrote:
> <snipped>
> >> Also, it is always useful to quote versions of relevant software -
> >> what version of wpa_supplicant, and networkmanager you are using; or
> >> even what distribution you are using, and hardware (64-bit, 32-bit).
> >> You have written 3 times and added no new info.
> >
> > You need only ask. :)
> 
> That info should have been in your first post, or the 2nd...

The first post contained all the information that I felt at the time was
relevant. The second post existed solely to get people to notice me (by
the way, how was it "no use"? I seem to have gotten someone to listen to
me...). If I was wrong in my initial assumption, it is completely within
your capability to correct me without sounding as if I've put some sort
of terrible burden on your head for no reason.

> And you still have not answered one: what distro - that alone would
> have answered or at least hinted at most of the software versions,
> etc.

I'm sorry for not answering this question, somehow I overlooked it. I'm
using Gentoo, which is why my wpa_supplicant is so old - 0.5.7 is the
newest stable version in Gentoo (no idea why).

> 'read my mind'... you are the person asking for help, why do you
> expect others to *chase after you* for info?

Please quit with this "read my mind" crap. If I were asking you to read
my mind, I would not be telling you the information you ask me for or
demanding results before I tell you the required information. I am doing
neither of these things. And also, the fact that you've had to ask me
some questions hardly means you're having to "chase after" anything.

> Most people won't bother.

Most people want to improve the software they write. If they didn't,
posting to this mailing list would be pointless.

> > I am using wpa_supplicant 0.5.7. I am aware that this is a really old version,
> > and I can try updating it if you think that would make a difference. I am running
> > on a Thinkpad T61, which is 64-bit. I think I already said which chip I'm using,
> > but I'll say it again. It's an IWL4965.
> 
> Now we are getting somewhere - and my first reply did ask you to run
> wpa_supplicant in the foreground.
> Even for the 0.5.x series, 0.5.10 is current... and most people are
> using 0.6.x . wpa_supplicant (not the driver) is responsible for
> encryption and authentication, and you had a deauthentication problem.
> Hello, anybody home??!!

Given that the version I'm using *CAN* authenticate, it doesn't
immediately make sense to me why wpa_supplicant would be causing this
problem, unless wpa_supplicant is intentionally trying to screw me up by
deauthenticating me. I will try updating, but would you please try a
little harder to hide the fact that you consider me a retard for no
reason next time? Thanks.

> So, as you yourself suggested, you should update. And while you are at
> it, read wpa_supplicant's doc, and work out the debug options and what
> I meant by 'run it in the foreground'.

I know what foreground means. If you look at my response, I guessed that
you meant in order to get debugging messages, which clearly shows that I
knew what you were talking about. And I have in fact tried this (even
before you suggested it), but have run into other problems. I'll try
again.

Ari

