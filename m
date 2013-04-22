Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:47795 "EHLO
	linville-x1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754646Ab3DVS7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 14:59:25 -0400
Date: Mon, 22 Apr 2013 14:52:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: pull request: b43-next 2013-04-13
Message-ID: <20130422185256.GC2055@tuxdriver.com> (sfid-20130422_205931_400379_BFFC9257)
References: <CACna6rxduYfWw2B+tHLSGTC-m0hDf3=dTWCFq6twjK2kpCuqwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rxduYfWw2B+tHLSGTC-m0hDf3=dTWCFq6twjK2kpCuqwg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 13, 2013 at 02:12:02AM +0200, Rafał Miłecki wrote:
> John,
> 
> I wanted to ask you for pulling b43 changes queued for 3.10. They are all
> sitting in my git repo at infradead I've announced a few weeks ago.
> 
> Changes include:
> 1) Minor improvements for HT-PHY code (BCM4331)
> 2) Code cleaning for HT-PHY and N-PHY
> They are mostly coming from me, but I've also included Hauke's minor cleanup.
> 
> All patches were posted (and I believe all of them reviewed) on b43-dev ML.
> 
> I've used various hardware to cover and test all code paths that has been
> touched. That included BCM4321, BCM4322 and BCM43224. No regressions spotted.
> I've also built b43 for my Broadcom SoC based router to test HT-PHY code on
> BCM4331.
> 
> Please let me know if that looks OK and if you can pull this tree, or if there
> are any problems.
> 
> 
> The following changes since commit 9cc04d692c031bf2113338b03974511670ac5cc9:
> 
>   Merge branch 'master' of
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
> (2013-03-27 17:33:52 -0400)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/rafal/b43-next.git master
> 
> for you to fetch changes up to adca58e2b4f350e9a93ca6c953be3f8e76ed541e:
> 
>   b43: N-PHY: don't use deprecated b43_radio_foo16 (2013-04-13 01:32:48 +0200)

When I pull this, I get a bunch of non-b43 (even non-wireless) crap.
My guess is that your tree is not based off wireless-next.

If you want me to pull from your tree, then it needs to be based off
wireless-next (or possible some ancestor tree) so that all I pull
from you is your specific changes.

With time running short before the 3.10 merge window, perhaps you
should resend this batch as a series of patches?  We can work more
on pull requests after the merge window?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
