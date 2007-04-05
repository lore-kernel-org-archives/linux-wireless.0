Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.237]:29328 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767273AbXDET5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 15:57:34 -0400
Received: by nz-out-0506.google.com with SMTP id s1so382998nze
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2007 12:57:34 -0700 (PDT)
Message-ID: <43e72e890704051257n1ae26c64k3e05614bea843729@mail.gmail.com>
Date: Thu, 5 Apr 2007 15:57:33 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Theo de Raadt" <deraadt@cvs.openbsd.org>
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Cc: "Pavel Roskin" <proski@gnu.org>, "Michael Buesch" <mb@bu3sch.de>,
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
In-Reply-To: <200704051937.l35JbSQh011320@cvs.openbsd.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <1175801487.19303.52.camel@dv>
	 <200704051937.l35JbSQh011320@cvs.openbsd.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/5/07, Theo de Raadt <deraadt@cvs.openbsd.org> wrote:
> > On Thu, 2007-04-05 at 12:48 -0600, Theo de Raadt wrote:
> >
> > > No, your message offered that he can come begging, because that is the
> > > best that thieves may do.
> > >
> > > Come little dog, come beg for forgiveness.
> > >
> > > You are a very poor example of humankind.
> >
> > Theo,
> >
> > I'm a member of linux-wireless list, an occasional contributor to
> > bcm43xx and a MadWifi developer.
> >
> > It has been a few months ago that I was feeling bad for another OpenBSD
> > driver developer.  The MadWifi team asked him to relicense parts of the
> > driver (so called openhal) under GPL so that if would be easier for us
> > to erase the boundary between the HAL and the rest of MadWifi and
> > eventually integrate it into the Linux kernel.
>
> Which OpenBSD devleoper did you feel bad for?  Reyk?  Reyk was going
> to relicence it? HAHAHA.  Man have you ever got it wrong.  Reyk
> totally gets to decide that, since he wrote it -- and he said NO you
> repeatedly.
>
> In the end, he asked ME to stop you guys from mailing him.
>
> How do you think you can rewrite history when the person who has sole
> license (Reyk) will say your history is totally false?
>
> Reyk was THRILLED that I finally told you guys to get lost
>
> > We got a message from you, which was rather abusive, and it just made
> > impossible for that OpenBSD developer to do anything but to deny our
> > request.  I was feeling bad for him, because it was his code.  I would
> > not want to be in a similar situation.
>
> The Linux people who wanted our atheros dirver got a numerous NICE
> reply messages from me Reyk and me saying NO, THE DRIVER WILL NOT BE
> RELICENCED.
>
> It got to the point where we were receiving one message requesting it
> every few days, and then you guys even sicked Lessig on us, to have
> him request the same.  Why did we have to relicence it?  Oh my -- we
> were told that "No, Linus will not let a BSD driver into the Linux
> tree".  As if we care for that problem.
>
> It was exceedingly rude how we received the same requests, over and
> over and over, week after week after week.
>
> Eventually, yes, we were rude and very strong: OVER OUR DEAD BODIES
> THE ATHEROS DRIVER WILL NOT BE RE-LICENSED TO BE GPL OR DUAL.  PERIOD.
>
> You guys had a choice to listen the first few times.  You were assholes
> to request it week after week after week.
>
> Don't go rewriting history.  There was never any point in time when
> it was going to be relicenced, and if you want to be sorry for what
> happene with Reyk, you can go and apologize to him for perstering
> him so long.
>
> > Now you are asking us to be sensitive towards somebody who just took the
> > code under GPL and put it under BSD license without asking any
> > questions, nicely or otherwise.
>
> What Marcus did was an accident.  You REFUSE to believe it was an
> accident.  The driver has now been deleted.  Do you feel better?

I personally feel that the fact that it was deleted was due more to
your temperament than a proper resolution to this. The fact that the
driver was deleted is a mistake in my eyes. All in all, I see wireless
as an area where FOSS community does need to work together. I have
said this before and this is why I try to dual license GPL/BSD any
code I write and encourage others to do so. Due to the lack of
corporate interest and legal regulatory concerns though [1] I think we
should start trying to put a bigger effort into working together. You
can call me an idealist but I am trying to do what I can to help FOSS
with wireless through an operating system agnostic approach. I realize
I can't convince everyone to do so but I invite those willing GPL
developers to help by Dual licensing their code as GPL/BSD and by the
BSD community to not regard us as enemies but simply developers of a
GPL operating system and as such restricted by its recursive licensing
constraints.

Please understand that the fact that Linux is under the GPL prohibits
us from accepting purely BSD licensed code, it's not Linus' decision
-- that is just the way the license works. Since Linux cannot accept
purely BSD licensed code it does not mean we do not want to
collaborate. We can dual license our code though and that is an
acceptable license for Linux, the kernel. Fortunately for us BSD
licensed code allows developers to take that code and GPL their own
version of the code, by keeping the original copyright intact.
Unfortunately for you and the entire BSD developer community the GPL
license does not grant those same rights on GPL licensed code, unless
dual licensed. This is just the nature of our differences and we need
to understand this is no ones fault, and that ultimately individual
copyright holders can act differently.

[1] http://linuxwireless.org/en/vendors/VendorSupport

  Luis
