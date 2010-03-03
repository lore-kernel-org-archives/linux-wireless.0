Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plexity.net ([206.123.115.38]:54122 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab0CCSxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 13:53:18 -0500
Date: Wed, 3 Mar 2010 10:52:31 -0800
From: Deepak Saxena <dsaxena@plexity.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: dsaxena@laptop.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, Nicolas Pitre <nico@marvell.com>
Subject: Re: [PATCH] libertas: add auto auth mode feature
Message-ID: <20100303185231.GA14009@plexity.net>
Reply-To: dsaxena@plexity.net
References: <1267146996-3725-1-git-send-email-bzhao@marvell.com> <1267225266.14995.7.camel@localhost.localdomain> <20100301195948.GA19200@plexity.net> <201003021302.10039.holgerschurig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201003021302.10039.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mar 02 2010, at 13:02, Holger Schurig was caught saying:
> > support is an option our community would be happy with. However, I also
> > don't want to end up with a libertas fork (all our mesh patches are
> > currently upstream and not forkd off)
> 
> Oh, sorry for being misinformed and spreading this misinformation. I had some 
> read-only variables in the mainline libertas driver (for example  
> mesh_autostart_enabled get's never written to) and heard that this is a 
> remnant, and that the real implementation in in the OLPC tree.

That is definitely a remnant of old work and our tree seems to have the
same read-only issues.

> Therefore I thought that you're sticking to some older kernel, and not 
> following mainline linux at all.

We're currently on 2.6.31, which I guess is somewhat  pre-historic by 
kernel development standards. We do have some patches to Libertas which 
were co-developed along with Marvell to fix some bugs we've discovered
during the XO-1.5 ramp up process and unfortunately we were on a really 
tight release schedule and not all of those have been pushed upstream, 
including some changes to the SDIO stack that were needed for proper
suspend/resume support on the gen 2 laptops. I'll be working on moving 
our kernel up to a newer version and will send up any patches that
we need merged and will also work with our users to figure out what
to do about mesh testing.

~Deepak

-- 
"People think all we need to fix our predicament is a free source of
energy, but I think we need to change out behaviour. More energy would
just deplete the Earth's lifeblood faster." - Janine Benyius
