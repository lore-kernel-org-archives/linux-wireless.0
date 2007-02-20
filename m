Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web50209.mail.yahoo.com ([206.190.38.50]:25851 "HELO
	web50209.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965765AbXBTAkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 19:40:17 -0500
Date: Mon, 19 Feb 2007 16:40:15 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Kernel bug in bcm43xx-d80211
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1171931043.8133.4.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <325621.23689.qm@web50209.mail.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--- Pavel Roskin <proski@gnu.org> wrote:

> On Mon, 2007-02-19 at 15:48 -0800, Alex Davis wrote:
> > --- Pavel Roskin <proski@gnu.org> wrote:
> > 
> > > On Mon, 2007-02-19 at 13:48 -0800, Alex Davis wrote:
> > > > I go the following Oops with the latest wireless-dev git when starting wpa_supplicant:
> > > 
> > > Wireless topics moved from this list to linux-wireless@vger.kernel.org.
> > > Broadcom drivers are discussed in bcm43xx-dev@lists.berlios.de.
> > > wireless-dev is horribly broken, and the fixes haven't been merged yet.
> > > 
> > > The current Broadcom driver can be loaded from
> > > http://bu3sch.de/git/wireless-dev.git (please load it on top of
> > > wireless-dev.git to save bandwidth)
> > What command do I use to load Mike's tree on top of wireless-dev?
> 
> This should do it for you:
> 
> git-remote add bcm43xx http://bu3sch.de/git/wireless-dev.git
> git-branch bcm43xx
> git-config branch.bcm43xx.remote bcm43xx
> git-config branch.bcm43xx.merge refs/heads/master
> git-checkout bcm43xx
> git-pull
> 
> Sorry, I didn't expect it to be so hairy.  Perhaps it should be
> documented somewhere.
> 
> -- 
> Regards,
> Pavel Roskin

I appreciate all the help, but now I'm confused. I got these instructions from Larry Finger:
git branch michael
git checkout michael
git pull http://bu3sch.de/git/wireless-dev.git master

And these instructions from Pavel Roskin:
git-remote add bcm43xx http://bu3sch.de/git/wireless-dev.git
git-branch bcm43xx
git-config branch.bcm43xx.remote bcm43xx
git-config branch.bcm43xx.merge refs/heads/master
git-checkout bcm43xx
git-pull

Which set of instructions do I use? Are either of these still applicable, seeing as I was asked
to pull from Jiri Benc's tree?

Thanks


I code, therefore I am


 
____________________________________________________________________________________
Be a PS3 game guru.
Get your game face on with the latest PS3 news and previews at Yahoo! Games.
http://videogames.yahoo.com/platform?platform=120121
