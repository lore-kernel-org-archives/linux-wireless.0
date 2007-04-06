Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cvs.openbsd.org ([199.185.137.3]:36234 "EHLO cvs.openbsd.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbXDFAYW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 20:24:22 -0400
Message-Id: <200704060019.l360Jf5u029134@cvs.openbsd.org>
To: Pavel Roskin <proski@gnu.org>
cc: Michael Buesch <mb@bu3sch.de>, Joseph Jezak <josejx@gentoo.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Marcus Glocker <mglocker@openbsd.org>,
	Jon Simola <jsimola@gmail.com>,
	Theo de Raadt <deraadt@theos.com>,
	Martin Langer <martin-langer@gmx.de>,
	Danny van Dyk <kugelfang@gentoo.org>,
	Andreas Jaggi <andreas.jaggi@waterwave.ch>,
	Larry Finger <larry.finger@lwfinger.net>, Quaker.Fang@sun.com,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	Greg kh <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
Subject: Re: OpenBSD bcw: Possible GPL license violation issues 
In-reply-to: Your message of "Thu, 05 Apr 2007 15:31:27 EDT."
             <1175801487.19303.52.camel@dv>
Date: Thu, 05 Apr 2007 18:19:41 -0600
From: Theo de Raadt <deraadt@cvs.openbsd.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm a member of linux-wireless list, an occasional contributor to
> bcm43xx and a MadWifi developer.
> 
> It has been a few months ago that I was feeling bad for another OpenBSD
> driver developer.  The MadWifi team asked him to relicense parts of the
> driver (so called openhal) under GPL so that if would be easier for us
> to erase the boundary between the HAL and the rest of MadWifi and
> eventually integrate it into the Linux kernel.
> 
> We got a message from you, which was rather abusive, and it just made
> impossible for that OpenBSD developer to do anything but to deny our
> request.  I was feeling bad for him, because it was his code.  I would
> not want to be in a similar situation.

Pavel,

To counter your complete fabrications above, here is the final part of
the real story about Reyk's Atheros driver.  This mail exchange
happened after repeated pestering mailings to Reyk and me, months and
months in a row, from Luis R. Rodriguez and his minions.

Pavel, you fabricated that entire story in the 2 paragraphs above.

---
To: Eben Moglen <moglen@softwarefreedom.org>
cc: deraadt
Subject: Re: Provenance of OpenBSD 802.11a Atheros drivers 
In-reply-to: Your message of "Wed, 11 Oct 2006 11:57:43 EDT."
             <17709.5239.289099.818075@new.law.columbia.edu> 
Date: Wed, 11 Oct 2006 11:57:58 -0600
From: Theo de Raadt <deraadt@cvs.openbsd.org>

> Clients of the Software Freedom Law Center have approached us for
> advice in connection with a project to adapt OpenBSD's Atheros drivers
> for use with Linux.

Hi.

Your clients have been spamming us for nearly a year trying to get us
to dual-license our code.  Having been rebuffed repeatedly, they are
now questioning the provinance of the codebase which they earlier just
wanted a dual-license to.  I urge you to consider who you are
representing.  They crossed to the other side of the line of "zeal"
quite a while ago.

Your client refuses to believe us that the code is clean, and I I
guess now they are going to waste your time over it too.

> They have been presented with unsubstantiated
> information suggesting problems with the provenance of code.

Reyk's work has now been in our tree for roughly 2 years.  Atheros was
aware of his effort since even before that, and they used to threaten
him for even starting a reverse engineering effort.  Reyk lives in
Germany, and OpenBSD is based in Canada.  Since his driver went into
our tree Atheros have not communicated towards us any direct way, not
even an email.

We have received no threats or anything from them directly; Atheros
employees have however levelled accusations of that kind fairly often,
voicing them privately to any parties who show an interest in reusing
our code, or making comments in public talks.  The unsubstantiated
information your clients are bringing to you is privately mailed
accusations from Sam Leffler, an employee of Atheros, who is the paid
author of the closed-source vendor driver.  Other accusations are
coming from Sam's close friend who also works inside Atheros, in a
higher position.

Those accusations are false.

> Before
> taking any other steps, given that the information suggesting trouble
> is itself unreliable, I wanted to ask you if /you/ have any reason to
> worry about that code.

I have no reason to worry about the code.

I was communicating with Reyk when the whole process of reverse
engineering was going on, and I saw the code go through the standard
"bug, fix, bug, fix" cycle.  I also saw him disassembling chunks of
the code, and doing all the other crazy procedures one has to when
doing reverse engineering.  He was constantly amazed at how bizzare
their architecture was, and on our discussion forums often ridiculed
the complexity of all the abstraction layers he was trying to dig
through.  He spent more than a year making it work.  The tail end of
this process is visible in our CVS logs.  It was clearly a monumental
effort.

We will readily admit that even today his driver does not have
complete support for all Atheros chip families.  In particular, only
about half of the Atheros radios work correctly.  Some of them can
only tune 802.11b frequencies, or 802.11a, or vice versa.  That's
because there is no documentation at all!  If the whole reverse
engineering process was a fraud, and this was done in some wrong way
as Atheros employees allege, the driver would be much more complete
and bugfree.  However even today 2 years later it is very much a "sort
of works" situation.

We have much significantly better support for many other wireless
devices.  This is mostly because the Atheros chipsets are way more
complicated and buggy than other vendor's products.

> Obviously, if there is need of a cleanroom
> reimplementation, my clients would apply resources to the creation of
> an implementation that could be licensed appropriately for use in
> multiple free operating system kernels, but if you know the code to be
> clean in origin, that should be sufficient in itself.

It was a clean process.  It was done by one person.  If it had not
been done by that one super dedicated person, today there would be no
free Atheros code.  It is under an ISC style licence.

We are, by the way, absolutely uninterested in any dual license
considerations, so the Linux people will have to accept the ISC-style
license.  Your client will have to accept that situation as well,
since we have repeatedly told him so.

If that is not acceptable to them, they are free to read Reyk's driver
and write their own by reading our code.  That is precisely the waste
of time we are often forced to do -- where we read GPL'd Linux drivers
for enough information to write our own BSD/ISC/MIT licensed versions,
quite often after Linux vendors have signed NDAs to receive vendor
documentation.  If your clients choose to go that route they should
note that all the code will be freely readable in the end, and we will
be watching for copyright violations, and we will take them seriously.
It is my personal belief that the lack of love from GPL believers has
freed me from any responsibility to show love towards them.

Good luck helping them.  I am sad that it always has to come to this
bullshit infighting. 


As an aside.... If your client truly cared about the history of source
code, and risk to the Linux source tree, I would suggest they look at
some of the entirely unlicensed header files in Linux which contain
vendor microcode.  They entirely lack a copyright notice, but
obviously came from a vendor.  Since these files lack any notice which
grants rights no rights have been granted.

