Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:65358 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766729AbXDFKyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 06:54:08 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1159809uga
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2007 03:54:06 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Date: Fri, 6 Apr 2007 12:53:20 +0200
Cc: Theo de Raadt <deraadt@cvs.openbsd.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
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
References: <200704052328.l35NSg8F020269@cvs.openbsd.org> <200704061104.50009.IvDoorn@gmail.com> <200704061114.02480.mb@bu3sch.de>
In-Reply-To: <200704061114.02480.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200704061253.21137.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 April 2007 11:14, Michael Buesch wrote:
> On Friday 06 April 2007 11:04, Ivo van Doorn wrote:
> > > I don't think he intentionally did it.
> > 
> > Ok, so it was only the commit that was perhaps accidental, it does mean
> > that he should be more carefull about what he is exactly committing.
> 
> We should not confuse that it was not "the commit", but the code has
> been committed in several commits. (I didn't count them)
> A mistake several times in a row? Isn't that unlikely to be a mistake them?

Hehe, well there are 2 scenarios for this:
1) The commits were all done without thinking about what was being committed,
    the code was not reviewed, and apparently the committed had no idea what
    the license of his own code and of the code he copied from meant.
2) The commits were done on purpose, making the commits a direct and severe
    GPL-violation.

If it was scenario 1, then I suggest Theo should be more strict towards his developers
and be more clear on what can and cannot be committed. Also I would recommend
that within his team the commits are better monitored to prevent these "mistakes"
in the future.

If it was scenario 2, then I suggest Theo will follow the same suggestions as I described
for scenario 1, but in addition should have some harsh talk towards his developers
regarding licenses, and he shouldn't start hide behind a discussion that is more about
whethere to have a "public" or "private" email regarding these issues.

Note that with both scenarios I have described it is clear that a big mistake was made
on the side of the BSD team, and it is that which should be addressed and not the
question if a public or private mail should be send to first start a discussion about the
violation.

Ivo
