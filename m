Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:61588 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754206AbYLGQPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 11:15:41 -0500
Message-ID: <493BF6AA.7030602@lwfinger.net> (sfid-20081207_171544_340227_10348FCC)
Date: Sun, 07 Dec 2008 10:15:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Yuval Hager <yuval@avramzon.net>
CC: Peter Stuge <peter@stuge.se>,
	wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de
Subject: Re: BCM4312 Fails when xdm is started
References: <200811151801.02369.yuval@avramzon.net> <200811250745.22487.yuval@avramzon.net> <20081125071818.9256.qmail@stuge.se> <200812071129.32113.yuval@avramzon.net>
In-Reply-To: <200812071129.32113.yuval@avramzon.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yuval Hager wrote:
> 
> This issue has been tracked down to be at the openchrome driver. It appears 
> that somehow it corrupted the PCI bus, and damaged the device right after the 
> video card - the wireless card. 
> 
> The current workaround for this is here - 
> http://wiki.openchrome.org/pipermail/openchrome-devel/2008-November/000139.html - 
> but this is just a quick hack, not a fix, although it works great for me. The 
> openchrome team is working on a patch based on this.
> 
> Thanks for all the help - I am a very happy HP2133 user, and a very happy 
> community member. This was an amazing opensource support experience, which 
> I'll remember for a long time. Thank you all!

Thanks for the feedback. The community may struggle a bit on some problems, and
the approach to a solution may look like a drunken sailor's walk, but we usually
get there.

Larry

