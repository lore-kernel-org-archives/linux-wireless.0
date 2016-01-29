Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38252 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbcA2IIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 03:08:32 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	kbuild test robot <lkp@intel.com>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: wireless-drivers: random cleanup patches piling up
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
	<1453423965.3856.22.camel@perches.com>
	<87k2n1x0sf.fsf@kamboji.qca.qualcomm.com>
	<20160122151211.GB1500@tuxdriver.com>
	<87si1pvcd7.fsf@kamboji.qca.qualcomm.com>
	<20160126052823.GA2053@sudip-laptop>
Date: Fri, 29 Jan 2016 10:08:23 +0200
In-Reply-To: <20160126052823.GA2053@sudip-laptop> (Sudip Mukherjee's message
	of "Tue, 26 Jan 2016 10:58:23 +0530")
Message-ID: <87bn84kdu0.fsf@kamboji.qca.qualcomm.com> (sfid-20160129_090935_458419_7298F5B2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

>> >> That's also my experience from maintaining wireless-drivers for a year,
>> >> this seems to be a "hit and run" type of phenomenon.
>> >
>> > Should we be looking for someone to run a "wireless-driver-cleanups"
>> > tree?  They could handle the cleanups and trivial stuff, and send
>> > you a pull request a couple of times per release...?
>> 
>> Not a bad idea! But I don't think we need a separate tree as applying
>> patches from patchwork is easy. It should be doable that we add an
>> account to patchwork and whenever I see a this type of trivial cleanup
>> patch I'll assign it to the cleanup maintainer and whenever he/she
>> thinks it's ready he assigns the patch back to me and I'll apply it.
>> 
>> The only difficult part is finding a victim/volunteer to
>> do that ;)
>
> I can be a volunteer (victim?). Though i donot know much about
> wireless-drivers, but I do know a little about cleanup patches.
> And maybe, in the process I will start knowing wireless-drivers.

I think it's better that you have prior experience with linux-wireless
before doing something like this. You can start by reviewing patches and
providing Reviewed-by tags.

-- 
Kalle Valo
