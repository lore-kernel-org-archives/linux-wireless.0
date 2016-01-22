Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42422 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbcAVPPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 10:15:15 -0500
Date: Fri, 22 Jan 2016 10:12:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	kbuild test robot <lkp@intel.com>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: wireless-drivers: random cleanup patches piling up
Message-ID: <20160122151211.GB1500@tuxdriver.com> (sfid-20160122_161534_554764_1A7A1D54)
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
 <1453423965.3856.22.camel@perches.com>
 <87k2n1x0sf.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <87k2n1x0sf.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2016 at 02:21:20PM +0200, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > On Thu, 2016-01-21 at 16:58 +0200, Kalle Valo wrote:
> >> Hi,
> >> 
> >> I have quite a lot of random cleanup patches from new developers waiting
> >> in my queue:
> >> 
> >> https://patchwork.kernel.org/project/linux-wireless/list/?state=10&delegate=25621&order=date
> >> 
> >> (Not all of them are cleanup patches, there are also few patches
> >> deferred due to other reasons, but you get the idea.)
> >> 
> >> These cleanup patches usually take quite a lot of my time and I'm
> >> starting to doubt the benefit, compared to the time needed to dig
> >> through them and figuring out what to apply. And this is of course time
> >> away from other patches, so it's slowing down "real" development.
> >> 
> >> I really don't know what to do. Part of me is saying that I just should
> >> drop them unless it's reviewed by a more experienced developer but on
> >> the other hand this is a good way get new developers onboard.
> >> 
> >> What others think? Are these kind of patches useful?
> >
> > Some yes, mostly not really.
> >
> > While whitespace style patches have some small value,
> > very few of the new contributors that use tools like
> > "scripts/checkpatch.pl -f" on various kernel files 
> > actually continue on to submit actual defect fixing
> > or optimization or code clarity patches.
> 
> That's also my experience from maintaining wireless-drivers for a year,
> this seems to be a "hit and run" type of phenomenon.

Should we be looking for someone to run a "wireless-driver-cleanups"
tree?  They could handle the cleanups and trivial stuff, and send
you a pull request a couple of times per release...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
