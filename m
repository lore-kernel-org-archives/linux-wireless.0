Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44610 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732233AbeHCM0r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 08:26:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wireless <linux-wireless@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mt76x0: build driver only as module
References: <20180803091401.GB10284@redhat.com>
        <87zhy36c4n.fsf@kamboji.qca.qualcomm.com>
        <20180803092822.GD10284@redhat.com>
        <20180803100939.GE10284@redhat.com>
Date: Fri, 03 Aug 2018 13:31:01 +0300
In-Reply-To: <20180803100939.GE10284@redhat.com> (Stanislaw Gruszka's message
        of "Fri, 3 Aug 2018 12:09:40 +0200")
Message-ID: <87va8r68t6.fsf@kamboji.qca.qualcomm.com> (sfid-20180803_123118_478362_B9C045D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Fri, Aug 03, 2018 at 11:28:22AM +0200, Stanislaw Gruszka wrote:
>> > But this feels like an ugly hack to me. Isn't there a better way to fix
>> > this? (I don't have time to investigate the error in detail right now.)
>> 
>> Yes, rename symbols names. And I will do this, just wanted to provide
>> quick fix for the problem. 
>> 
>> Moreover seems the same thing should be done for mt7601u to avoid build
>> errors and perhaps with mt76 :-( 
>> 
>> So I'm going to rename functions.
>
> I have the patches, I'm building kernel with allyesconfig now,
> it will take a while ...

I'm now hoping to send the pull request tomorrow, so if you can submit a
proper patch some time today that would be good.

-- 
Kalle Valo
