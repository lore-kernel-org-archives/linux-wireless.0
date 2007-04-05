Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cvs.openbsd.org ([199.185.137.3]:39562 "EHLO cvs.openbsd.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767422AbXDEXcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 19:32:04 -0400
Message-Id: <200704052328.l35NSg8F020269@cvs.openbsd.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
cc: Johannes Berg <johannes@sipsolutions.net>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Pavel Roskin <proski@gnu.org>, Michael Buesch <mb@bu3sch.de>,
	Joseph Jezak <josejx@gentoo.org>,
	Marcus Glocker <mglocker@openbsd.org>,
	Jon Simola <jsimola@gmail.com>,
	Theo de Raadt <deraadt@theos.com>,
	Martin Langer <martin-langer@gmx.de>,
	Danny van Dyk <kugelfang@gentoo.org>,
	Andreas Jaggi <andreas.jaggi@waterwave.ch>,
	Larry Finger <larry.finger@lwfinger.net>, Quaker.Fang@sun.com,
	John Linville <linville@tuxdriver.com>,
	Greg kh <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
Subject: Re: OpenBSD bcw: Possible GPL license violation issues 
In-reply-to: Your message of "Fri, 06 Apr 2007 00:59:24 +0200."
             <200704060059.24876.IvDoorn@gmail.com>
Date: Thu, 05 Apr 2007 17:28:42 -0600
From: Theo de Raadt <deraadt@cvs.openbsd.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > >  * removed their attribution
> >=20
> > The attribution was never to be added, because a couple of functions
> > were copied in temporarily to help development of other functions, and
> > then they were accidentally commited.
> 
> To be honest it is completely beyond me how somebody manages
> to read code, considers it usefull (and thus has read the code in such a way
> that he was searching for something usefull), copy'n'paste the code and com=
> mits
> the code to cvs. And at the end of the day claims that it is an accident.

As I understand it, Marcus' process involved borrowing a few pieces of
the GPL codebase during his development process, so that he could
write further stubs in other parts.  Then his process was supposed to
involve him commiting the pieces he had written himself, but not the
momentarily written GPL parts.  And that is where a mistake happened;
as I understand it.

I don't think he intentionally did it.

I think anyone who thinks he intentionally did it should give him a
phone call and judge from the voice conversation with him if he did.
I invite one person from here to do it.  Anyone willing to?

Otherwise, I warn you -- you are making a rather strong statement of
accusation.

> > It was an accident for him to commit it. =A0But it was no accident you
> > decided to make a public fuss about it. =A0Now you have your public
> > fuss.
> 
> Everybody can make his own choice on the manner in which the violation is b=
> eing
> reported. Yes, Michael could have send a private mail, but he could also ha=
> ve made
> the violation even more public by adding some mail address that would have =
> started
> an even bigger flamewar.
> But note that 75% of the people following this thread would not have taken =
> too much
> interest into this violation when you did not jump into the trenches and st=
> arting to insult
> people in order to make a big fuzz about it

I am only here to point out that a gang of people publically jumping on
ONE DEVELOPER is an unacceptable process in any 'community'.

I am very sure that most of the senior Linux developers have the maturity
to try a personal mail to someone who they see a problem with.

By sending a private mail that was so strongly worded, Michael showed that
he lacks that maturity.

> You have your reasons for wanting a discussion about the GPL violation priv=
> ate, Michael
> had his reasons for making more people aware of the situation. Just because=
>  somebody
> does not share the same opinion as you don't make him "inhumane", "harming =
> cooperation
> between open source projects". Neither is it true that somebody is
> "Not being supportive to the open source community" when he cannot fulfill =
> your request/demand.

His mail was without any empathy, and shows a lack of understanding of the
human mode of operation.

> I wonder what upsets you most, the fact that openBSD is not perfect in term=
> s of that the code
> contains a GPL violation or that you were forced into a public debate about=
>  this while you prefer
> to flame and insult people privately.


OpenBSD is not perfect, no, not at all.  Neither is OpenSSH.
