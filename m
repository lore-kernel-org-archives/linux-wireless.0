Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48704 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbeAWFOg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 00:14:36 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [1/2] mt76: fix possible NULL pointer dereferencing in mt76x2_ampdu_action()
References: <18a56326d68a7d53f3197e450cae0e28382d8d2c.1513252573.git.lorenzo.bianconi@redhat.com>
        <5835442f-9e10-69bb-3b6d-d207d540181f@nbd.name>
        <87o9lsczf4.fsf@kamboji.qca.qualcomm.com>
        <9978263.24XfVAzbPX@bentobox>
Date: Tue, 23 Jan 2018 07:14:31 +0200
In-Reply-To: <9978263.24XfVAzbPX@bentobox> (Sven Eckelmann's message of "Wed,
        17 Jan 2018 16:56:46 +0100")
Message-ID: <87zi5540nc.fsf@codeaurora.org> (sfid-20180123_061441_547347_EA7B1703)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven@narfation.org> writes:

> On Mittwoch, 17. Januar 2018 16:50:23 CET Kalle Valo wrote:
> [...]
>> >> I didn't see Felix's ack, at least not on patchwork.
>> >
>> > I sent my ack (for both patches) as a reply to 0/2
>> 
>> Ah. patchwork is annoying as it doesn't show the cover letter at all so
>> I missed that.
>
> Newer version at least can track the series and their cover letters. This is 
> not completely what you want but at least there is hope. Here is an example: 
> https://patchwork.open-mesh.org/cover/17240/ (you can use "Related" to see all 
> the patches in the series).

Nice, looking forward to see that version in patchwork.kernel.org. My
ultimate goal is that I could doo all my maintenance work via my
patchwork script and not touch my email client at all. That's getting
closer.

-- 
Kalle Valo
