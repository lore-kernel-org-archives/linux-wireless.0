Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nemesis.fprintf.net ([66.134.112.218]:3331 "EHLO
	nemesis.fprintf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030287AbXBGP1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 10:27:50 -0500
Subject: Re: RFT bcm43xx: Really _GOOD_ news
From: Daniel Gryniewicz <dang@fprintf.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Gene Heskett <gene.heskett@verizon.net>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
In-Reply-To: <1170836250.11150.116.camel@dv>
References: <45C8E64B.1050605@lwfinger.net>
	 <200702061848.00815.gene.heskett@verizon.net>
	 <45C95830.6040507@lwfinger.net>
	 <200702070303.40968.gene.heskett@verizon.net>
	 <1170836250.11150.116.camel@dv>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 10:21:05 -0500
Message-Id: <1170861665.6964.4.camel@athena.fprintf.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-02-07 at 03:17 -0500, Pavel Roskin wrote:
> On Wed, 2007-02-07 at 03:03 -0500, Gene Heskett wrote:
> 
> > And the 4318 is whats in my lappy.  What does it break?
> 
> Oh, please, let's stop such questions.  Does it really matter what some
> knowingly wrong change does to particular hardware?  Just don't try the
> old patch.  Just forget that it existed.  It's not going to the kernel.
> 
> Please try the new patch.  Ideally, measure speeds for various rates,
> because it's the speed that the patch is supposed to improve.
> 
> If you have more questions of this kind, please make sure my personal
> e-mail is not in CC.
> 

Except that the new patch changes nothing for us poor 4318 users, so
what's the point of trying it?

That said, I'm running the broken patch right now, and my 4318 is
working better than ever before, so it changed *something* for my card.

Daniel

