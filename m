Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbYBUClN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 21:41:13 -0500
Subject: Re: airo WPA
From: Dan Williams <dcbw@redhat.com>
To: Matteo Croce <matteo@openwrt.org>
Cc: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>,
	Matthieu Castet <castet.matthieu@free.fr>,
	Fabrice Bellet <fabrice@bellet.info>,
	"John W. Linville" <linville@tuxdriver.com>,
	PReDaCoN <alessandroferrari@gmail.com>,
	Benjamin Reed <breed@users.sourceforge.net>,
	Javier Achirica <achirica@users.sourceforge.net>,
	Jean Tourrilhes <jt@hpl.hp.com>,
	linux-wireless@vger.kernel.org, linux-net@vger.kernel.org
In-Reply-To: <200802210155.53337.matteo@openwrt.org>
References: <200711070307.09832.rootkit85@yahoo.it>
	 <200711071559.47916.rootkit85@yahoo.it>
	 <1194448388.23721.0.camel@localhost.localdomain>
	 <200802210155.53337.matteo@openwrt.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 21:34:04 -0500
Message-Id: <1203561244.17712.8.camel@localhost.localdomain> (sfid-20080221_024133_538508_C70FA9F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-02-21 at 01:55 +0100, Matteo Croce wrote:
> Il Wednesday 07 November 2007 16:13:08 Dan Williams ha scritto:
> > Well, ideally we push the patch upstream and then people can send
> > updates to this list...  I think it's really close and I feel like it
> > can be submitted for 2.6.25.
> > 
> > Dan
> 
> I've seen so many updates in GIT, so I applied all up to 3eb9b41f...ae9e76e4 to my 2.6.24 kernel and it compiles, loads and runs fine, but there are no WPA commits.
> Where is the WPA version that should go in 2.6.25? There are repository or patches floating around? I offer myself as betatester, I'm really interested in this.

It never quite got over the finish line.  This is partly my fault as I'd
been cleaning up some of the patches.  There's an SVN repository at:

http://svn.gna.org/viewcvs/airo-wpa/branches/kernel/

and Fabrice had some patches on top of the SVN stuff that made it work
better.  Many of Fabrice's patches would need to be applied before it
could be upstreamed.

However, the hardware I had was never able to survive a TKIP rekey
without just going into a coma (reliable with WEP though).  It just
wasn't reliable enough to turn on or push upstream yet.  The effort sort
of died after that; I was going to try to capture the frames around the
time of the TKIP rekey to see what might be the issue but hadn't gotten
around to it.

Dan


