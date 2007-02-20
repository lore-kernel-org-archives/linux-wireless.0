Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:39521 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965823AbXBTAvP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 19:51:15 -0500
Date: Tue, 20 Feb 2007 01:51:12 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Alex Davis <alex14641@yahoo.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Kernel bug in bcm43xx-d80211
Message-ID: <20070220015112.6b8e1658@logostar.upir.cz>
In-Reply-To: <325621.23689.qm@web50209.mail.yahoo.com>
References: <1171931043.8133.4.camel@dv>
	<325621.23689.qm@web50209.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 Feb 2007 16:40:15 -0800 (PST), Alex Davis wrote:
> I appreciate all the help, but now I'm confused. I got these instructions from Larry Finger:
> git branch michael
> git checkout michael
> git pull http://bu3sch.de/git/wireless-dev.git master

This is easier for one-time pull.

> And these instructions from Pavel Roskin:
> git-remote add bcm43xx http://bu3sch.de/git/wireless-dev.git
> git-branch bcm43xx
> git-config branch.bcm43xx.remote bcm43xx
> git-config branch.bcm43xx.merge refs/heads/master
> git-checkout bcm43xx
> git-pull

This is useful if you want to pull regularly. But Larry's way can be used
even in that case - I'm pulling regularly from wireless-dev and never used
git-config :-)

Also, Larry's advice about getting back to the original wireless-dev tree
could be useful for you. It applies to both Larry's and Pavel's
instructions.

> Which set of instructions do I use? Are either of these still applicable, seeing as I was asked
> to pull from Jiri Benc's tree?

If you pull from my tree, you won't be able to compile any d80211 driver.
The wireless statistics fixes need to be committed by John first.

 Jiri

-- 
Jiri Benc
SUSE Labs
