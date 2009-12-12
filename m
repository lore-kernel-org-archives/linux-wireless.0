Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51401.mail.re2.yahoo.com ([206.190.38.180]:23594 "HELO
	web51401.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760847AbZLLJkV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 04:40:21 -0500
Message-ID: <56469.79651.qm@web51401.mail.re2.yahoo.com>
References: <500577.32161.qm@web51405.mail.re2.yahoo.com> <200912101846.40572.holgerschurig@gmail.com>  <43e72e890912100914m1766db5fife6563fec3807b8d@mail.gmail.com>  <200912111739.55225.holgerschurig@gmail.com> <43e72e890912110841k2a49ec19w9e29ad66a9165030@mail.gmail.com>
Date: Sat, 12 Dec 2009 01:40:28 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: AW: Switching channel in IBSS network doesn't work in ath9k
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890912110841k2a49ec19w9e29ad66a9165030@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iw feature was a side note. What about the channel switch? Can you
reproduce this? Is this supposed to work?

 -- 
Regards 
Joerg 




----- Ursprüngliche Mail ----
> Von: Luis R. Rodriguez <mcgrof@gmail.com>
> An: Holger Schurig <holgerschurig@googlemail.com>
> CC: Joerg Pommnitz <pommnitz@yahoo.com>; ath9k-devel@lists.ath9k.org; linux-wireless@vger.kernel.org
> Gesendet: Freitag, den 11. Dezember 2009, 17:41:48 Uhr
> Betreff: Re: Switching channel in IBSS network doesn't work in ath9k
> 
> On Fri, Dec 11, 2009 at 8:39 AM, Holger Schurig
> wrote:
> >> Actually I think a simple 'iw link' to do this for all interfaces
> >> would be good. I just haven't gotten around to it. I should be
> >> possible without upstream changes I believe.
> >
> > Do you think that "iw link" should also show then info when the device is in
> > monitor mode (e.g. return the flags) or in IBSS mode?  And probably also
> > reporting parts of the survey data, e.g. noise floor?
> >
> > That would be the equivalent of a "give me the greatest amount of info
> > quickly" :-)
> 
> I do but johill is the maintainer, see what he thinks :)
> 
>   Luis


__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
