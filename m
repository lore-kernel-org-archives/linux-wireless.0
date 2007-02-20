Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:55076 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965777AbXBTAsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 19:48:37 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HJJ9y-0007tf-1N
	for linux-wireless@vger.kernel.org; Mon, 19 Feb 2007 19:47:10 -0500
Subject: Re: Kernel bug in bcm43xx-d80211
From: Pavel Roskin <proski@gnu.org>
To: Alex Davis <alex14641@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <325621.23689.qm@web50209.mail.yahoo.com>
References: <325621.23689.qm@web50209.mail.yahoo.com>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 19:48:34 -0500
Message-Id: <1171932514.8133.12.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-02-19 at 16:40 -0800, Alex Davis wrote:

> I appreciate all the help, but now I'm confused. I got these
> instructions from Larry Finger:
> git branch michael
> git checkout michael
> git pull http://bu3sch.de/git/wireless-dev.git master
> 
> And these instructions from Pavel Roskin:
> git-remote add bcm43xx http://bu3sch.de/git/wireless-dev.git
> git-branch bcm43xx
> git-config branch.bcm43xx.remote bcm43xx
> git-config branch.bcm43xx.merge refs/heads/master
> git-checkout bcm43xx
> git-pull
> 
> Which set of instructions do I use? Are either of these still
> applicable, seeing as I was asked
> to pull from Jiri Benc's tree?

The only difference is that I provided git-remote and git-config
commands that would change the configuration to make "git pull" work
every time without arguments on both branches, whereas if you follow
Larry's instructions, you'll need to provide the URL and the branch to
merge every time you are on the "michael" branch.

The name of the branch is different, but it's your choice.  "git-XXX" is
equivalent to "git XXX", but I prefer the former because bash will
complete the command.  Again, it doesn't really matter.

-- 
Regards,
Pavel Roskin

