Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cvs.openbsd.org ([199.185.137.3]:13117 "EHLO cvs.openbsd.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbXDDW0J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 18:26:09 -0400
Message-Id: <200704042222.l34MMYCr009965@cvs.openbsd.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Marcus Glocker <mglocker@openbsd.org>,
	Jon Simola <jsimola@gmail.com>,
	Theo de Raadt <deraadt@theos.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
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
In-reply-to: Your message of "Wed, 04 Apr 2007 22:08:13 +0200."
             <200704041945.21447.mb@bu3sch.de>
Date: Wed, 04 Apr 2007 16:22:34 -0600
From: Theo de Raadt <deraadt@cvs.openbsd.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  [citing Michael, Date unknown]
> "What if Broadcom decides to take our LO measure state machine and
> put it into the original driver? (The Rev Engineers told me they have
> a very different weird solution for this in their code).
> I really don't want to see this happen."

For the record, I want to warn you that you CANNOT COPYRIGHT
A STATE MACHINE, which is what the above sentence implies.

You can copyright the actual way it is written ('expression'), but you
CANNOT copyright 'mechanism' or 'interface'.  Copyright only covers
what is called 'expression', and that of course is subject to judicial
interpretation.  But a state machine to solve a problem is not
expression.

When you start talking about copyrighting state machines, youy
are talking about using copyright as a new style of patent law.
That's not what it does.

Whoever Michael is, that comment above about using the GPL as a patent
like tool is crazy.  And if you think that the GPL has any binding
against Broadcom copying the idea of your state machine, you are
quite deluded.
