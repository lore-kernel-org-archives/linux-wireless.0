Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:40936 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbXDFJFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 05:05:37 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1148719uga
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2007 02:05:36 -0700 (PDT)
To: Theo de Raadt <deraadt@cvs.openbsd.org>
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Date: Fri, 6 Apr 2007 11:04:49 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
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
References: <200704052328.l35NSg8F020269@cvs.openbsd.org>
In-Reply-To: <200704052328.l35NSg8F020269@cvs.openbsd.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200704061104.50009.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > To be honest it is completely beyond me how somebody manages
> > to read code, considers it usefull (and thus has read the code in such a way
> > that he was searching for something usefull), copy'n'paste the code and com=
> > mits
> > the code to cvs. And at the end of the day claims that it is an accident.
> 
> As I understand it, Marcus' process involved borrowing a few pieces of
> the GPL codebase during his development process, so that he could
> write further stubs in other parts.  Then his process was supposed to
> involve him commiting the pieces he had written himself, but not the
> momentarily written GPL parts.  And that is where a mistake happened;
> as I understand it.
> 
> I don't think he intentionally did it.

Ok, so it was only the commit that was perhaps accidental, it does mean
that he should be more carefull about what he is exactly committing.
(A nice idea would be to double check the commit by reading the commit-mail
if it is being generated, that has helped me on multiple occassions for detecting
a problem in my commits)

> I think anyone who thinks he intentionally did it should give him a
> phone call and judge from the voice conversation with him if he did.
> I invite one person from here to do it.  Anyone willing to?
> 
> Otherwise, I warn you -- you are making a rather strong statement of
> accusation.

Well normally I am not the person making very strong accusations into any directions,
but in this case I consider the accusations that come from my mail justified especially
regarding your wish to keep the discussion private to resolve these kinds of issues
peacefully. I do know what you understand by those private discussions to resolve issues
"peacefully", and it basically comes down to having the same effect that is happening now
only on a smaller scale and more one-sides (from your direction when you don't get what you want).
The benefit from that private discussion is that nobody outside of that discussion
knows what went on, and what you understand with "civilized" discussions.

> > > It was an accident for him to commit it. =A0But it was no accident you
> > > decided to make a public fuss about it. =A0Now you have your public
> > > fuss.
> > 
> > Everybody can make his own choice on the manner in which the violation is b=
> > eing
> > reported. Yes, Michael could have send a private mail, but he could also ha=
> > ve made
> > the violation even more public by adding some mail address that would have =
> > started
> > an even bigger flamewar.
> > But note that 75% of the people following this thread would not have taken =
> > too much
> > interest into this violation when you did not jump into the trenches and st=
> > arting to insult
> > people in order to make a big fuzz about it
> 
> I am only here to point out that a gang of people publically jumping on
> ONE DEVELOPER is an unacceptable process in any 'community'.

True a gang of people jumping on 1 person is unacceptable, unfortunately
for you I don't think that has happened to your developer...
You jumped into the discussion when 1 man (on hehalf of his team) send a mail
to 1 other man, and CC'ed several other people that one way or another where
involved or should be aware of the issue.
After that the multiple replies from the Linux community were send in response to
your mails. You can check that yourself by looking who everybody has in the TO field
of the email, the one developer you are defending has been (except for 2 or 3 mails)
in the CC list, all other mails have been directed to you.

> I am very sure that most of the senior Linux developers have the maturity
> to try a personal mail to someone who they see a problem with.

Like I said in my previous mail, everybody has his methods for dealing
with a particular problem. Some do it privately, other try to involve more
people (who are one way or another are involved in the situation) to resolve
the problem and trying to find a solution.

> By sending a private mail that was so strongly worded, Michael showed that
> he lacks that maturity.

See me above statement, it has nothing to do with maturity it has everything to do
with making a choice that you feel is best for everybody.

> > You have your reasons for wanting a discussion about the GPL violation priv=
> > ate, Michael
> > had his reasons for making more people aware of the situation. Just because=
> >  somebody
> > does not share the same opinion as you don't make him "inhumane", "harming =
> > cooperation
> > between open source projects". Neither is it true that somebody is
> > "Not being supportive to the open source community" when he cannot fulfill =
> > your request/demand.
> 
> His mail was without any empathy, and shows a lack of understanding of the
> human mode of operation.

*sigh* ok lets rephrase my sentence then:
Just becausr somebody does not share the same opinion as you don't make him "inhumane",
"lacking emphathy", "lack of understanding of the human mode of operation" or
"harming cooperation between open source projects".
Neither is it true that somebody is "Not being supportive to the open source community"
when he cannot fulfill your request/demand.

I hope this point is now clear enough.

> > I wonder what upsets you most, the fact that openBSD is not perfect in term=
> > s of that the code
> > contains a GPL violation or that you were forced into a public debate about=
> >  this while you prefer
> > to flame and insult people privately.
> 
> 
> OpenBSD is not perfect, no, not at all.  Neither is OpenSSH.

I assume that means that you are indeed most upset that your were forced into
a public debate about this while you prefer to flame and insult people privately.

I wonder why you keep bringing openSSH into this discussion, we already _know_ that you
and your team of developers wrote that. And everybody does use openSSH. But apparently
your ego needs those facts to be confirmed quite often.

Ivo
