Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62054 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab1AUTto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 14:49:44 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 11:49:25 -0800
Date: Fri, 21 Jan 2011 11:48:40 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: Greg KH <greg@kroah.com>
CC: Vipin Mehta <Vipin.Mehta@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH 00/83] staging: ath6kl: Style cleanup
Message-ID: <20110121194840.GA18603@vmehta-desktop>
References: <1295637798-18355-1-git-send-email-vmehta@atheros.com>
 <20110121193830.GA17789@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110121193830.GA17789@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 21, 2011 at 11:38:30AM -0800, Greg KH wrote:
> On Fri, Jan 21, 2011 at 11:23:18AM -0800, Vipin Mehta wrote:
> > The following set of patches fixes the driver's coding style in 
> > accordance with the Linux kernel coding style. The patches ended 
> > being huge so putting them up on a shared location where they can 
> > be retrieved using wget.
> > 
> > http://userweb.kernel.org/~vmehta/ath6kl-cleanup.tar.bz2
> 
> Interesting, however the very first patch fails to apply :(

I generated the patches after rebasing my tree to the remotes/origin/staging-linus in the staging-2.6 tree. I tested it again just a whilw back and the patches do apply.
> 
> So, care to make up a git tree that I could pull these from?  Or at the
> least, rebase them so that I can apply them?

There is git tree here which was originally pulled from the staging-2.6 tree and has all these changes.

http://git.kernel.org/?p=linux/kernel/git/vmehta/ath6kl.git;a=shortlog;h=refs/heads/ath6kl-cleanup

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/vmehta/ath6kl.git
Head: ath6kl-cleanup
> 
> thanks,
> 
> greg k-h
