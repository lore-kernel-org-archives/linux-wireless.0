Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44010 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaKYOtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 09:49:07 -0500
Received: by mail-pd0-f178.google.com with SMTP id g10so689530pdj.37
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 06:49:07 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 25 Nov 2014 22:49:07 +0800
Message-ID: <CAFuUQkibQ0o5H=5b4ZQyiadiPuoU8gY+5pg9TyqKLzMvV3q2SA@mail.gmail.com> (sfid-20141125_154921_684484_2B993A83)
Subject: Re: [PATCH] mac80211: check if channels allow 80 MHz for VHT probe requests
From: YanBo <dreamfly281@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, j@w1.fi,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2014 at 10:18 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2014-11-25 at 22:13 +0800, YanBo wrote:
>
>> > But is all of that really the right way? I'm not completely convinced.
>>
>> Except set the flag, the HW itself should support this feature, or
>> else it also doesn't work, I'd
>> send the patch in soon for public review.
>
> Yeah, but is it really the right way to advertise VHT? In the spec, VHT
> means you also have 80 MHz support - do you really think you can/will do
> 80 MHz on 2.4 GHz? Seems like all of this will cause more corner cases.
>
>> >

Agree with you that it need a bigger discussion about whether
advertise VHT is the suitable/best
way to support the  VHT at 2.4G feature.

We are considered this ways as it is already be used by some vendor
like BRCM or Qualcomm Atheros
in there full mac product, and there will be IOT issue if there are
kinds of different implementation.

Thanks
BR /Yanbo
