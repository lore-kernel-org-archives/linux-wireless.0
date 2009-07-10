Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56228 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZGJPPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 11:15:55 -0400
Date: Fri, 10 Jul 2009 11:06:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, Celejar <celejar@gmail.com>
Subject: Re: Fwd: 4318 misbehaving with bleeding edge kernels
Message-ID: <20090710150602.GB2825@tuxdriver.com>
References: <200907101131.41781.mb@bu3sch.de> <1247237986.3210.10.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1247237986.3210.10.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 10, 2009 at 10:59:46AM -0400, Pavel Roskin wrote:
> On Fri, 2009-07-10 at 11:31 +0200, Michael Buesch wrote:
> 
> > I have a 4318 (rev 02), which has been working fine with b43.
> > Recently, with 2.6.31-rc2 kernels from the wireless-testing git repo,
> > I've been having trouble.  Sometimes the card simply fails to associate
> > after doing 'iwconfig eth0 essid xxxx'.  It doesn't even seem to try;
> > i.e., when it does associate, I see log entries like these:
> 
> I believe is that the ESSID support in the wext compatibility layer is
> seriously broken.  It's not shown originally at all.  Once it's set, it
> cannot be changed.

What kernel are you using?  I don't see this behavior...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
