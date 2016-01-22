Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53810 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbcAVMSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 07:18:00 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: wireless-drivers: random cleanup patches piling up
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
	<CAGRGNgVDhqGdC4NrWgTAbhGKtodTGsMVJ-QGdXG_hPWYeuGe4g@mail.gmail.com>
Date: Fri, 22 Jan 2016 14:17:52 +0200
In-Reply-To: <CAGRGNgVDhqGdC4NrWgTAbhGKtodTGsMVJ-QGdXG_hPWYeuGe4g@mail.gmail.com>
	(Julian Calaby's message of "Fri, 22 Jan 2016 09:32:56 +1100")
Message-ID: <87oacdx0y7.fsf@kamboji.qca.qualcomm.com> (sfid-20160122_131804_908534_C804CB30)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

> Hi Kalle,
>
> On Fri, Jan 22, 2016 at 1:58 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
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
> I'm not experienced or knowledgeable enough

I have seen your comments, you are most certainly knowledgeable enough :)

> to give an ack or formal review of a patch, however I generally read
> all of them. Would it be helpful if I were to give an informal "this
> patch looks sane" for cleanups and other small patches?

That would be _very_ helpful, especially with these cleanup patches from
newbies.

And even better if you can add the official Reviewed-by tag because when
we get the promised patchwork update (crossing my fingers) it will
actually show the review count on the top page. That makes it really
easy to spot what cleanup patches are worth looking at (and which one to
drop). So I very much welcome this practice.

-- 
Kalle Valo
