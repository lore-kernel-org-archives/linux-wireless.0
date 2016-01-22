Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60043 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbcAVPyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 10:54:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	kbuild test robot <lkp@intel.com>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: wireless-drivers: random cleanup patches piling up
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
	<1453423965.3856.22.camel@perches.com>
	<87k2n1x0sf.fsf@kamboji.qca.qualcomm.com>
	<20160122151211.GB1500@tuxdriver.com>
Date: Fri, 22 Jan 2016 17:54:12 +0200
In-Reply-To: <20160122151211.GB1500@tuxdriver.com> (John W. Linville's message
	of "Fri, 22 Jan 2016 10:12:12 -0500")
Message-ID: <87si1pvcd7.fsf@kamboji.qca.qualcomm.com> (sfid-20160122_165425_528805_A1FFC17F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Fri, Jan 22, 2016 at 02:21:20PM +0200, Kalle Valo wrote:
>> Joe Perches <joe@perches.com> writes:
>> 
>> > On Thu, 2016-01-21 at 16:58 +0200, Kalle Valo wrote:
>> >> Hi,
>> >> 
>> >> I have quite a lot of random cleanup patches from new developers waiting
>> >> in my queue:
>> >> 
>> >> https://patchwork.kernel.org/project/linux-wireless/list/?state=10&delegate=25621&order=date
>> >> 
>> >> (Not all of them are cleanup patches, there are also few patches
>> >> deferred due to other reasons, but you get the idea.)
>> >> 
>> >> These cleanup patches usually take quite a lot of my time and I'm
>> >> starting to doubt the benefit, compared to the time needed to dig
>> >> through them and figuring out what to apply. And this is of course time
>> >> away from other patches, so it's slowing down "real" development.
>> >> 
>> >> I really don't know what to do. Part of me is saying that I just should
>> >> drop them unless it's reviewed by a more experienced developer but on
>> >> the other hand this is a good way get new developers onboard.
>> >> 
>> >> What others think? Are these kind of patches useful?
>> >
>> > Some yes, mostly not really.
>> >
>> > While whitespace style patches have some small value,
>> > very few of the new contributors that use tools like
>> > "scripts/checkpatch.pl -f" on various kernel files 
>> > actually continue on to submit actual defect fixing
>> > or optimization or code clarity patches.
>> 
>> That's also my experience from maintaining wireless-drivers for a year,
>> this seems to be a "hit and run" type of phenomenon.
>
> Should we be looking for someone to run a "wireless-driver-cleanups"
> tree?  They could handle the cleanups and trivial stuff, and send
> you a pull request a couple of times per release...?

Not a bad idea! But I don't think we need a separate tree as applying
patches from patchwork is easy. It should be doable that we add an
account to patchwork and whenever I see a this type of trivial cleanup
patch I'll assign it to the cleanup maintainer and whenever he/she
thinks it's ready he assigns the patch back to me and I'll apply it.

The only difficult part is finding a victim/volunteer to
do that ;)

-- 
Kalle Valo
