Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33691 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbcAVNNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 08:13:54 -0500
Received: by mail-ig0-f181.google.com with SMTP id z14so10526726igp.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2016 05:13:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87oacdx0y7.fsf@kamboji.qca.qualcomm.com>
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com> <CAGRGNgVDhqGdC4NrWgTAbhGKtodTGsMVJ-QGdXG_hPWYeuGe4g@mail.gmail.com>
 <87oacdx0y7.fsf@kamboji.qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 23 Jan 2016 00:13:34 +1100
Message-ID: <CAGRGNgV8A+H_UsOpNTQLaHunvm=raaAoagMKQqFJkvE9hms8Cg@mail.gmail.com> (sfid-20160122_141358_933724_B11FE5AE)
Subject: Re: wireless-drivers: random cleanup patches piling up
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Fri, Jan 22, 2016 at 11:17 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Julian Calaby <julian.calaby@gmail.com> writes:
>
>> Hi Kalle,
>>
>> On Fri, Jan 22, 2016 at 1:58 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Hi,
>>>
>>> I have quite a lot of random cleanup patches from new developers waiting
>>> in my queue:
>>>
>>> https://patchwork.kernel.org/project/linux-wireless/list/?state=10&delegate=25621&order=date
>>>
>>> (Not all of them are cleanup patches, there are also few patches
>>> deferred due to other reasons, but you get the idea.)
>>>
>>> These cleanup patches usually take quite a lot of my time and I'm
>>> starting to doubt the benefit, compared to the time needed to dig
>>> through them and figuring out what to apply. And this is of course time
>>> away from other patches, so it's slowing down "real" development.
>>>
>>> I really don't know what to do. Part of me is saying that I just should
>>> drop them unless it's reviewed by a more experienced developer but on
>>> the other hand this is a good way get new developers onboard.
>>>
>>> What others think? Are these kind of patches useful?
>>
>> I'm not experienced or knowledgeable enough
>
> I have seen your comments, you are most certainly knowledgeable enough :)

I'm glad one of us has confidence in me. I know general stuff, but I
lack driver / subsystem specific knowledge, i.e. I can tell if
someone's patch looks stupid, but I can't generally tell if the end
result is doing the "right" thing. Thankfully most of the small
cleanup patches aren't generally changing anything that significant.

>> to give an ack or formal review of a patch, however I generally read
>> all of them. Would it be helpful if I were to give an informal "this
>> patch looks sane" for cleanups and other small patches?
>
> That would be _very_ helpful, especially with these cleanup patches from
> newbies.
>
> And even better if you can add the official Reviewed-by tag because when
> we get the promised patchwork update (crossing my fingers) it will
> actually show the review count on the top page. That makes it really
> easy to spot what cleanup patches are worth looking at (and which one to
> drop). So I very much welcome this practice.

Ok, done. I'll give any sane patches my reviewed-by with a brief "this
looks sane" note.

I'll also try to ensure the maintainers of the driver are CC'd on my
reply and ask them to review the more technical stuff if it's
required.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
