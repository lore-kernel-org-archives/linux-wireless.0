Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53898 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbcAVMV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 07:21:27 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, kbuild test robot <lkp@intel.com>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: wireless-drivers: random cleanup patches piling up
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
	<1453423965.3856.22.camel@perches.com>
Date: Fri, 22 Jan 2016 14:21:20 +0200
In-Reply-To: <1453423965.3856.22.camel@perches.com> (Joe Perches's message of
	"Thu, 21 Jan 2016 16:52:45 -0800")
Message-ID: <87k2n1x0sf.fsf@kamboji.qca.qualcomm.com> (sfid-20160122_132133_013007_8D3A9829)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Thu, 2016-01-21 at 16:58 +0200, Kalle Valo wrote:
>> Hi,
>> 
>> I have quite a lot of random cleanup patches from new developers waiting
>> in my queue:
>> 
>> https://patchwork.kernel.org/project/linux-wireless/list/?state=10&delegate=25621&order=date
>> 
>> (Not all of them are cleanup patches, there are also few patches
>> deferred due to other reasons, but you get the idea.)
>> 
>> These cleanup patches usually take quite a lot of my time and I'm
>> starting to doubt the benefit, compared to the time needed to dig
>> through them and figuring out what to apply. And this is of course time
>> away from other patches, so it's slowing down "real" development.
>> 
>> I really don't know what to do. Part of me is saying that I just should
>> drop them unless it's reviewed by a more experienced developer but on
>> the other hand this is a good way get new developers onboard.
>> 
>> What others think? Are these kind of patches useful?
>
> Some yes, mostly not really.
>
> While whitespace style patches have some small value,
> very few of the new contributors that use tools like
> "scripts/checkpatch.pl -f" on various kernel files 
> actually continue on to submit actual defect fixing
> or optimization or code clarity patches.

That's also my experience from maintaining wireless-drivers for a year,
this seems to be a "hit and run" type of phenomenon.

-- 
Kalle Valo
