Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60457 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYJOT7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 15:59:44 -0400
Date: Wed, 15 Oct 2008 15:56:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dave <kilroyd@googlemail.com>
Cc: arvidjaar@mail.ru, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-10-14
Message-ID: <20081015195656.GC27688@tuxdriver.com> (sfid-20081015_215947_798660_34A2A42C)
References: <20081015013204.GH3349@tuxdriver.com> <48F6419B.80104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48F6419B.80104@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 08:16:43PM +0100, Dave wrote:
> John W. Linville wrote:
>> Here is a nice little batch of wireless fixes in time for 2.6.28-rc1.
>> There are also a few USB ID additions as well.  I think this is all
>> mostly obvious, and hopefully still acceptable at this stage.
>>
>> Please let me know if there are problems!
>
>> Andrey Borzenkov (1):
>>       orinoco: fix unsafe locking in orinoco_cs_resume
>
> Hi John,
>
> Just wanted to check whether you'd seen/intend to apply the orinoco patch Andrey posted in <http://marc.info/?l=linux-kernel&m=122365972026045&w=4>. It fixes a regression (vs 2.6.26) when using 4k stacks.
>
> Or whether you'd prefer that patch resent with an updated subject?

I have that thread in my patchbox -- thanks for reminding me why!

No need to resend..

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
