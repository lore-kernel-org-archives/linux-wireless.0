Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59685 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3GWHNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 03:13:54 -0400
Received: by mail-wg0-f48.google.com with SMTP id f11so6634645wgh.3
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jul 2013 00:13:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6487488.19IqyPtizJ@lx-vladimir>
References: <1374374808-12768-1-git-send-email-Larry.Finger@lwfinger.net>
 <1958736.oRuXAUfNGd@lx-vladimir> <20130722161554.GR17130@pogo> <6487488.19IqyPtizJ@lx-vladimir>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 23 Jul 2013 00:13:32 -0700
Message-ID: <CAB=NE6VVJifHW1MQJJMnRkHANkFSQ7kDwmCHBUS7_U6Y14P8OA@mail.gmail.com> (sfid-20130723_091357_614432_A51E048F)
Subject: Re: [PATCH] ath: wil6210: Fix build error
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 23, 2013 at 12:06 AM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
> On Monday, July 22, 2013 09:17:01 AM Luis R. Rodriguez wrote:
>> On Sun, Jul 21, 2013 at 10:06:31AM +0300, Vladimir Kondratiev wrote:
>> > Hmm, I have no warning for this with neither 3.10 nor 3.11 kernel version; but
>> > patch is correct, and here is my
>> > Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
>>
>> If you agree with a patch you don't say you Sign-off-by it as well,
>> you say Acked-by. The Signed-off-by tag has a very specific meaning
>> from development to a maintainer's hands, and its definition is on
>> the Developer Certificate or Origin.
>>
>> So in this case Acked-by is better.
>>
>>   Luis
>
> <drop most of CC>
>
> I thought that I need to add Signed-off-by: as driver's maintainer, because
> (quote Documentation/SubmittingPatches):
> ---
> The Signed-off-by: tag indicates that the signer was involved in the
> development of the patch, or that he/she was in the patch's delivery path.
> ---
>
> This is similar to other maintainers adding its Signed-off-by:.
> Or, is driver's maintainer an exception from the rule quoted above?

If you had a git tree, sure, otherwise not in this case.

 Luis
