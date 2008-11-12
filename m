Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23104.mail.ird.yahoo.com ([217.146.189.44]:37550 "HELO
	web23104.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752143AbYKLBkZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 20:40:25 -0500
Date: Wed, 12 Nov 2008 01:40:22 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: a couple of small bugs in compat-wireless -- libertas
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	"compat-masters@lists.madwifi.org" <compat-masters@lists.madwifi.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	dwmw2@infradead.org, dcbw@redhat.com, linville@tuxdriver.com,
	tim.gardner@canonical.com
In-Reply-To: <43e72e890811111702x7b817c4bpdeed5acf39b2a5fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <33409.76636.qm@web23104.mail.ird.yahoo.com> (sfid-20081112_024037_813002_E00AFAEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 12/11/08, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> From: Luis R. Rodriguez <mcgrof@gmail.com>
<snipped>
> > OK for your issue you can try this patch.
> 
> This patch should actually be useless to you as you
> probably are just
> downloading the tarball.. so just download the latest
> tarball, I just
> regenerated it with the patches applied.

Thanks for doing this - I actually do both: I have local git-clones of compat-wireless and and wireless-testing, which I use for checking out the "latest and greatest". However, to hunt down a regression which turned out to happen about 20 days ago, I had to roll back both of them and it was getting a bit painful to roll them back in sync, so I downloaded two whole months' worth of daily tarballs and bisected the "old fashion way" until I got within a day, then I read the tags off two daily snapshots and use the git-clone to spit out the 48 commits within that day. Some of the 48 are obviously irrelevant so it narrows it down to under 20 probables, and just a few obvious candidates. Then back to one of the snapshots and try out the obvious candidates; found the commit which breaks and verify that it breaks git-clone HEAD, etc. So it was going back and forth between the daily tarballs and the git-clones. 

Thanks for compat-wireless - it takes about 1/2 hour to build a snapshot (I just worked out how to edit the Makefile to skip some bits I
don't need, so it has gone quicker), but it is better than building a whole new kernel... and the best thing about it is that I don't have to reboot, just losing connectivity briefly (hopefully) to swap and try new snapshots.

Hin-Tak 


      
