Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1DCHqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2011 03:46:32 -0400
Subject: Re: products with Atheros AR9002U (UB94) ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven <srumney@sbcglobal.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110402T231743-492@post.gmane.org>
References: <AANLkTimERiSQcFp2-F5OTM6KyQHEMsGvJaWsV4w4Rsed@mail.gmail.com>
	 <AANLkTinabDMC7kN6Ryv23VUatGrAM1nt=Ue89Myq79qN@mail.gmail.com>
	 <loom.20110402T010759-583@post.gmane.org>
	 <201104021124.32057.chunkeey@googlemail.com>
	 <BANLkTingByKjmYu7wM07XO4ijqXz=ymWWw@mail.gmail.com>
	 <loom.20110402T231743-492@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Apr 2011 09:46:30 +0200
Message-ID: <1301816790.3984.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-04-02 at 21:25 +0000, Steven wrote:
> > Thanks for the set of responses!  It's been super helpful.  I am
> > checking out all of these options now.
> > 
> > It would still be great to add these to the "product list" on
> > linuxwireless.org, does anyone know how to add to this list?
> > http://linuxwireless.org/en/users/Devices/USB
> > 
> > Just to get an idea of this... but is the USB AR9280+AR7010 fully
> > supported already?  In checking some of the device driver pages,
> > ath9k_htc is listed as supporting AR9271+AR7010, but I don't see
> > ar9280 like I do ar9170.  I don't know if this is just a documentation
> > detail or not.
> 
> 
> For the product list email one of the admins- http://linuxwireless.org/about.

Not going to help, I'm not going to do it for ath9k_htc :-)

However, it's easy to have them added there automatically, see for
example http://wireless.kernel.org/en/users/Drivers/p54/devices

All it needs is a page called /en/users/Drivers/ath9k_htc/devices with
the right table format to be added automatically.

johannes

