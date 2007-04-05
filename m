Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:54912 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932334AbXDEAWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 20:22:24 -0400
Date: Thu, 5 Apr 2007 02:18:05 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Theo de Raadt <deraadt@cvs.openbsd.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Marcus Glocker <mglocker@openbsd.org>,
	Jon Simola <jsimola@gmail.com>,
	Theo de Raadt <deraadt@theos.com>,
	Martin Langer <martin-langer@gmx.de>,
	Danny van Dyk <kugelfang@gentoo.org>,
	Andreas Jaggi <andreas.jaggi@waterwave.ch>,
	Larry Finger <larry.finger@lwfinger.net>, Quaker.Fang@sun.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Joseph Jezak <josejx@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	Greg kh <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Message-ID: <20070405021805.5da85e5e@localhost>
In-Reply-To: <200704042139.l34LdX54017048@cvs.openbsd.org>
References: <200704041945.21447.mb@bu3sch.de>
	<200704042139.l34LdX54017048@cvs.openbsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[I'm another bcm43xx maintainer and copyright holder.]

On Wed, 04 Apr 2007 15:39:33 -0600
Theo de Raadt <deraadt@cvs.openbsd.org> wrote:

> Yes, this driver has other problems though.  To begin with, it does
> not even run yet, in any sense.  Since it is not actual using code,
> there will be those who argue that the full impact of the GPL does not
> come to bear yet -- noone is "using" the code yet.

Actually, I would be really happy if somebody was "using" the code. We (the
bcm43xx developers) already discussed about dual licensing on Dec,
2005, because we wanted *BSD as well to benefit from our effort. We
then decided not to dual-license any code, because of the reasons
Michael already explained. I thought Michael already expressed our concerns
about BSD license clearly enough, but it looks like he didn't. We aren't
talking about "usage" here, we just don't want proprietary vendors (i.e.
Broadcom) to benefit from our work. I think that we may have different
points of view on this issue, but I think as well that you can understand
our concerns.

> Because right now, in that mail, you've pretty much done Broadcom's
> job for them.  You've told the entire BSD community who may want to
> use a driver for this chip later, that because of a few GPL issues you

That's not what I would call "a few GPL issues". Really.

> are willing to use very strong words -- published very widely -- to
> disrupt the efforts of one guy who is trying to do things for them.

You are assuming that we want to disrupt his efforts. I think that this
blatant violation is a big bug for OpenBSD, and it looks you agree on this.
Do you believe in full disclosure, don't you?

> And, you are going to do this using the GPL, even.  You did not
> privately mail that developer.  No, you basically went public with it.

The bcw developers went public with it. This code was submitted to a
public CVS. With multiple commits. Copying comments. Maintaining
whitespace and variable names. Not even trying to hide that.

> That is how about half the user and developer community will see it.
> They will see your widely posted mail as an overly strong position.
> 
> And you have probably royally pissed of a developer working in
> parallel in the same problem space as youself.  Would you be happy to
> receive a mail like you just sent?  No, you would be really disturbed,
> to your soul.

Personally, I think that what would be more disturbing to my soul is
releasing GPL'd code under a different and incompatible license without even
asking people who wrote it.

> So next time, talk to the specific people, so you don't come off
> as being mean, ok?

Who is mean here? Again, we aren't out for blood. I don't care for who is
mean here. But if you do, you should be a bit more careful before insulting
people. Plus, I think the mail was sent to the specific people for this
issue. Would you please tell me who is not "specific" here?


--
Ciao
Stefano
