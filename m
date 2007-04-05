Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:51255
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767138AbXDERPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 13:15:19 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Theo de Raadt <deraadt@cvs.openbsd.org>
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Date: Thu, 5 Apr 2007 19:14:10 +0200
Cc: Marcus Glocker <marcus@nazgul.ch>,
	Marcus Glocker <mglocker@openbsd.org>,
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
References: <200704051648.l35GmYT9003711@cvs.openbsd.org>
In-Reply-To: <200704051648.l35GmYT9003711@cvs.openbsd.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200704051914.10999.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 April 2007 18:48, Theo de Raadt wrote:
> I personally believe that you made a very poor choice by publically
> attacking a developer who did not even have working code yet.  You chose

The GPL is not about "working code", it's about distribution.
And you did distribute our code under the BSD license, which is
a GPL violation.
I think this is dangerous, because the code is tainted and it
may even taint other codebases. For example if someone working
for opensolaris choses to import bcw into solaris, as he's rightfully
got the opinion that bcw is BSD licensed.

> not to mail him privately and point out your concerns.
> 
> Marcus has chosen to give up.

I want to publically state the I do NOT FEEL GUILTY for this.

I offered several ways to solve the issue that would help bcw development
(offering to relicense my code).
If Marcus gave up that's a pity. But that's his choice. I respect that,
although I hoped to get a better solution.

> Can you please stop mailing us about this?  It's over.  Your beloved
> license has been protected, and it's over.

I tried to make clear that this is NOT about the "GPL Religion",
but you obviously did not get it.
To say it again. We did _not_ choose the GPL, because "everybody
does this" or because we are bound to the GPL in any way.
We had good reasons to chose it, but we _always_ left the opportunity
to have parts of it relicensed for you guys.

-- 
Greetings Michael.
