Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:36168 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753934AbXJLBv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 21:51:56 -0400
From: bruno randolf <bruno@thinktube.com>
To: Markus Feldmann <feldmann_markus@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Patch for Kernel and Ath5k
Date: Fri, 12 Oct 2007 10:51:46 +0900
References: <feieb9$nvg$1@sea.gmane.org> <200710111516.44663.hs4233@mail.mn-solutions.de> <470E33D4.4060000@gmx.de>
In-Reply-To: <470E33D4.4060000@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710121051.47561.bruno@thinktube.com> (sfid-20071012_025200_550106_9E9BB7D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 11 October 2007 23:31:48 Markus Feldmann wrote:
> > Shouldn't you be on "everything" ?
> >
> > I'm using:
> >
> > rm -rf wireless-2.6
> > git clone --reference /usr/src/linux-git
> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
> > cd wireless-2.6
> > git checkout -b everything origin/everything
>
> I got this Message when i execute "git clone ...",
> reference repository '/usr/src/linux-git' is not a local directory
> any Idea?

just don't use this option then...

git clone \ 
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
cd wireless-2.6
git checkout -b everything origin/everything

-> exactly like its documented in 
http://linuxwireless.org/en/users/Drivers/ath5k#Hackingath5k

i know, git can appear overwhelming in the beginnig, but its rather easy once 
you get used to it. if you have known subversion before this document gets 
you started: http://git.or.cz/course/svn.html

anyhow you should read the instructions...

good luck,
bruno
