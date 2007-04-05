Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55483
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767149AbXDERku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 13:40:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Theo de Raadt <deraadt@cvs.openbsd.org>
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Date: Thu, 5 Apr 2007 19:40:03 +0200
Cc: Joseph Jezak <josejx@gentoo.org>,
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
References: <200704051705.l35H5KRn019095@cvs.openbsd.org>
In-Reply-To: <200704051705.l35H5KRn019095@cvs.openbsd.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200704051940.04407.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 April 2007 19:05, Theo de Raadt wrote:
> > He should start to contact us to get relicensing permission from
> > us to speed up bcw development and stay legal.
> 
> What bullshit.  He should contact you, when he does not known that
> he's been found to have made mistakes?
> 
> Do you even know the word 'mistake'?
> 
> If you make a mistake, sometimes you don't know it has been made
> until someone tells you that you have made a mistake.

I can't see how you can copy code from bcm43xx to bcw by mistake.
Really, I want to explicitely state that in my opinion the 1:1
copying was going on intentionally. This is impossible to be
a mistake.
Theo, please _do_ compare the code of bcw and bcm43xx. You will find
tons of 1:1 copied code.

> And you are surprised about what has happened?

Yes I am. I thought you were really interrested in having a Broadcom
wireless driver for openbsd.

> Are you living in 
> a cave?  Are you not human?  Don't you know how people behave when
> they are publically attacked, and not treated with respectful private
> discussion to point out their mistakes?

This was not a mistake. bcw developers obviously intentionally
copied our code. If you read the bcw commit logs and compare
bcm43xx and bcw code you will see what I mean. Yes, _really_ do this!
Compare it and you'll get my point.

> His deletion of the code has happened for one reason and one reason
> alone -- your way of trying to handle this.

I don't agree to this.
This sounds more like he lost interrest in getting a clean Broadcom
wireless driver.

-- 
Greetings Michael.
