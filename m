Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f179.google.com ([209.85.160.179]:49791 "EHLO
	mail-gy0-f179.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755902Ab2EGLCb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 07:02:31 -0400
Received: by ghbg19 with SMTP id g19so780701ghb.10
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 04:02:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <874nrs9sth.fsf@purkki.adurom.net>
References: <1336106215-7431-1-git-send-email-yeohchunyeow@gmail.com>
	<1336376603.4325.3.camel@jlt3.sipsolutions.net>
	<CAEFj9857DWGCcnF20nKYEDb0_p1K_iYLR1F=oLNAx6NjwPQE9w@mail.gmail.com>
	<1336382462.4325.4.camel@jlt3.sipsolutions.net>
	<CAEFj9855PG1Qv5RBWPJJc5tyKRz5LZZaY8qRU7oAwryH5G8L7A@mail.gmail.com>
	<874nrs9sth.fsf@purkki.adurom.net>
Date: Mon, 7 May 2012 18:54:38 +0800
Message-ID: <CAEFj985aZR3mh3J96m_fCwMVWaY4di8CGS=REUnzydh9h+7tCw@mail.gmail.com> (sfid-20120507_130235_539423_AF245037)
Subject: Re: [PATCH] fix the increment of unicast/multicast counters for
 forwarded PREQ
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Kalle,

Appreciate your explanation. I understand my mistake.

Thanks

Regards,
Chun-Yeow

On Mon, May 7, 2012 at 6:41 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:
>
>> Hi, Johannes
>>
>>>> >> +             if (da != broadcast_addr)
>>>
>>> will never be false.
>>
>> Hmm, but I have a check on this and it works. The previous line will
>> set the da either as broadcast addr or unicast addr.
>
> You are comparing pointers, not addresses. If you do that on purpose
> then it's very confusing.
>
> --
> Kalle Valo
