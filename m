Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from buzzloop.caiaq.de ([212.112.241.133]:51067 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab0DAR6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:04 -0400
Date: Thu, 1 Apr 2010 19:57:58 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Anders =?iso-8859-1?Q?Grafstr=F6m?=
	<grfstrm@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Sven Neumann <s.neumann@raumfeld.com>,
	LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
	AKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: Memory corruption with 2.6.32.10, but not with 2.6.34-rc3
Message-ID: <20100401175758.GQ30801@buzzloop.caiaq.de>
References: <20100401132156.GJ30807@buzzloop.caiaq.de>
 <4BB4D817.1050603@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4BB4D817.1050603@users.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 01, 2010 at 07:29:59PM +0200, Anders Grafström wrote:
> Daniel Mack wrote:
> > We would like to have a fix for this annoying bug in the stable series
> > (especially 2.6.32.x) as well, but I don't have much ideas about where
> > to search for it. Hence, I would appreciate if maintainers could think
> > about any possible commits in the described time window which haven't
> > reached stable. Does the description ring anyone's bell?
> > 
> > I can cherry-pick things if anyone pin-points something and run
> > lont-time tests again. Any pointer appreciated.
> 
> You could try this one:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8e4971f2fb2380ce66196136e113d04196b80fcd

Thanks. Unfortunately, that didn't fix it (this time, it crashed after a
few minutes only). But shouldn't we have that in -stable anyway?

Daniel

