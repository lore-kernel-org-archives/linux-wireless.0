Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:55179 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965677AbXBTAYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 19:24:06 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HJImF-00076s-Fj
	for linux-wireless@vger.kernel.org; Mon, 19 Feb 2007 19:22:39 -0500
Subject: Re: Kernel bug in bcm43xx-d80211
From: Pavel Roskin <proski@gnu.org>
To: Alex Davis <alex14641@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <508755.46267.qm@web50206.mail.yahoo.com>
References: <508755.46267.qm@web50206.mail.yahoo.com>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 19:24:03 -0500
Message-Id: <1171931043.8133.4.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-02-19 at 15:48 -0800, Alex Davis wrote:
> --- Pavel Roskin <proski@gnu.org> wrote:
> 
> > On Mon, 2007-02-19 at 13:48 -0800, Alex Davis wrote:
> > > I go the following Oops with the latest wireless-dev git when starting wpa_supplicant:
> > 
> > Wireless topics moved from this list to linux-wireless@vger.kernel.org.
> > Broadcom drivers are discussed in bcm43xx-dev@lists.berlios.de.
> > wireless-dev is horribly broken, and the fixes haven't been merged yet.
> > 
> > The current Broadcom driver can be loaded from
> > http://bu3sch.de/git/wireless-dev.git (please load it on top of
> > wireless-dev.git to save bandwidth)
> What command do I use to load Mike's tree on top of wireless-dev?

This should do it for you:

git-remote add bcm43xx http://bu3sch.de/git/wireless-dev.git
git-branch bcm43xx
git-config branch.bcm43xx.remote bcm43xx
git-config branch.bcm43xx.merge refs/heads/master
git-checkout bcm43xx
git-pull

Sorry, I didn't expect it to be so hairy.  Perhaps it should be
documented somewhere.

-- 
Regards,
Pavel Roskin

