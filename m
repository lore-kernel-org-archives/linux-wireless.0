Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33064 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbcAUWdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 17:33:16 -0500
Received: by mail-ig0-f182.google.com with SMTP id z14so134575349igp.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 14:33:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 22 Jan 2016 09:32:56 +1100
Message-ID: <CAGRGNgVDhqGdC4NrWgTAbhGKtodTGsMVJ-QGdXG_hPWYeuGe4g@mail.gmail.com> (sfid-20160121_233319_757024_47FADCE1)
Subject: Re: wireless-drivers: random cleanup patches piling up
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Fri, Jan 22, 2016 at 1:58 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Hi,
>
> I have quite a lot of random cleanup patches from new developers waiting
> in my queue:
>
> https://patchwork.kernel.org/project/linux-wireless/list/?state=10&delegate=25621&order=date
>
> (Not all of them are cleanup patches, there are also few patches
> deferred due to other reasons, but you get the idea.)
>
> These cleanup patches usually take quite a lot of my time and I'm
> starting to doubt the benefit, compared to the time needed to dig
> through them and figuring out what to apply. And this is of course time
> away from other patches, so it's slowing down "real" development.
>
> I really don't know what to do. Part of me is saying that I just should
> drop them unless it's reviewed by a more experienced developer but on
> the other hand this is a good way get new developers onboard.
>
> What others think? Are these kind of patches useful?

I'm not experienced or knowledgeable enough to give an ack or formal
review of a patch, however I generally read all of them. Would it be
helpful if I were to give an informal "this patch looks sane" for
cleanups and other small patches?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
