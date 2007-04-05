Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cvs.openbsd.org ([199.185.137.3]:48982 "EHLO cvs.openbsd.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767277AbXDEUNY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 16:13:24 -0400
Message-Id: <200704052010.l35KA9S6024250@cvs.openbsd.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: "Pavel Roskin" <proski@gnu.org>, "Michael Buesch" <mb@bu3sch.de>,
	"Joseph Jezak" <josejx@gentoo.org>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Marcus Glocker" <mglocker@openbsd.org>,
	"Jon Simola" <jsimola@gmail.com>,
	"Theo de Raadt" <deraadt@theos.com>,
	"Martin Langer" <martin-langer@gmx.de>,
	"Danny van Dyk" <kugelfang@gentoo.org>,
	"Andreas Jaggi" <andreas.jaggi@waterwave.ch>,
	"Larry Finger" <larry.finger@lwfinger.net>, Quaker.Fang@sun.com,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	"Greg kh" <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
Subject: Re: OpenBSD bcw: Possible GPL license violation issues 
In-reply-to: Your message of "Thu, 05 Apr 2007 15:57:33 EDT."
             <43e72e890704051257n1ae26c64k3e05614bea843729@mail.gmail.com>
Date: Thu, 05 Apr 2007 14:10:09 -0600
From: Theo de Raadt <deraadt@cvs.openbsd.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,

I ask you to first disclaim the statements Pavel made.  They are
false.  He tries to make it seem like I was blocking Reyk from dual
licensing of the Atheros, when that was entirely Reyk's choice.
Please correct Pavel, because his false accusations put the thread in
the wrong direction.

Luis, you should know, since you were one of the persons who pestered
us week by week.

> I personally feel that the fact that it was deleted was due more to
> your temperament than a proper resolution to this.

No, Marcus Glocker decided this entirely on his own accord.  I gave
him specific instructions to decide as he sees fit.  I told him I did
not want to influence him.

> The fact that the
> driver was deleted is a mistake in my eyes.

If I were to add this to Michael's statements, now Marcus is not just
a liar, a thief, but also mistaken.  AND he should spend time to fix
things after he's been called these things.  I'm just blown away by
the GPL community's generousity.

> All in all, I see wireless
> as an area where FOSS community does need to work together.

No kidding.

> I have
> said this before and this is why I try to dual license GPL/BSD any
> code I write and encourage others to do so. Due to the lack of
> corporate interest and legal regulatory concerns though [1] I think we
> should start trying to put a bigger effort into working together.

We should.  But it isn't happening, because publically one of the (I
will estimate) 10-12 BSD-side wireless developers has just been called
a thief and a liar.  If you think there were problems before, just
look at them now.

There is outrage over Michael's approach.

> You
> can call me an idealist but I am trying to do what I can to help FOSS
> with wireless through an operating system agnostic approach. I realize
> I can't convince everyone to do so but I invite those willing GPL
> developers to help by Dual licensing their code as GPL/BSD and by the
> BSD community to not regard us as enemies but simply developers of a
> GPL operating system and as such restricted by its recursive licensing
> constraints.

Maybe that is part of what Michael meant in his message; but such
statements made after accusing Marcus publically means that part of
the message is useless.  If Michael wanted to be the big man he could
say "OK, we decided that what Marcus has copied so far is OK, we give
him the rights as long as he puts the following notice up at the top".

But it is clear that Micheal expects that Marcus will now mail him
and ask for this.  If so, the joke is on him.

> Please understand that the fact that Linux is under the GPL prohibits
> us from accepting purely BSD licensed code, it's not Linus' decision
> -- that is just the way the license works.	

Quite frankly, that is hogwash.  It is a matter of interpretation.

And furthermore, none of Reyk's code is under the BSD license.  It is
under an ISC license:

/*
 * Copyright (c) 2004, 2005, 2006, 2007 Reyk Floeter <reyk@openbsd.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

The ISC license is a "all rights are granted except you must leave the text"
license.  It is the most minimal step above a pure Public Domain grant.

> Since Linux cannot accept
> purely BSD licensed code it does not mean we do not want to
> collaborate.

In many many mails you have been informed that it isn't BSD licensed,
and yet you keep calling it BSD licensed.  If you can't even read,
what kind of collaboration do you expect?

> We can dual license our code though and that is an
> acceptable license for Linux, the kernel.

We?  Sure, you can.  But Reyk will not dual license his code, and most
of the other people in the BSD community won't either, because then
they receive the occasional patch from a GPL-believer which is ONLY
under the GPL license, and then they are no less screwed than they
would be from the code granted totally freely to companies.

> Fortunately for us BSD
> licensed code allows developers to take that code and GPL their own
> version of the code, by keeping the original copyright intact.
> Unfortunately for you and the entire BSD developer community the GPL
> license does not grant those same rights on GPL licensed code, unless
> dual licensed.

No kidding.  Like when someone mails us explicitly GPL-only patches,
which has happened.  Therefore many of us reject the entire concept of
dual licensing.  It is a fraud which only benefits one side.  And when
it benefits only that one side, it makes us a second class citizen, So
you might as well get used to using our ISC-style code.


In the end though, this whole discussion is no longer about licensing,
but about an approach towards informing of problems.

But before you go Luis, be sure to make it clear that Pavel is
lying about the situation with Reyk's code.  Reyk never intended
to dual license his code, and Pavel's mail is more than a small
misunderstanding:

> We got a message from you, which was rather abusive, and it just made
> impossible for that OpenBSD developer to do anything but to deny our
> request.  I was feeling bad for him, because it was his code.  I would
> not want to be in a similar situation.

Bullshit, bullshit, bullshit.  Bringing up such a lie to try to make
Micheal's actions OK is just ridiculous.
