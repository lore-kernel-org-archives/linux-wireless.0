Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751424AbdIHJPI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:15:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ian W MORRISON <ianwmorrison@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Fwd: [PATCH v2] brcmfmac: feature check for multi-scheduled scan fails on bcm4345 devices
References: <3cfcb175-8031-f5a8-da51-d81fa2d331c8@gmail.com>
        <7481b892-511f-4696-bf3f-82b1bec50abf@broadcom.com>
        <CAFXWsS_c6kr8LyZi0x8j5d4gU0AU9JzhSrYxit10G2B7OC9F+A@mail.gmail.com>
        <87vakyobw9.fsf@kamboji.qca.qualcomm.com>
        <CAFXWsS-NxYqp-N9AFUCuQE-nknNorV25wevGJ7KkJuvMmHh6Og@mail.gmail.com>
Date: Fri, 08 Sep 2017 12:15:04 +0300
In-Reply-To: <CAFXWsS-NxYqp-N9AFUCuQE-nknNorV25wevGJ7KkJuvMmHh6Og@mail.gmail.com>
        (Ian W. MORRISON's message of "Fri, 8 Sep 2017 11:09:47 +1000")
Message-ID: <871snhlffr.fsf@kamboji.qca.qualcomm.com> (sfid-20170908_111512_643003_234FCBED)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ian,

please don't send me email privately, instead always send the questions
to the list. You get better answers faster and I get less email :)

Ian W MORRISON <ianwmorrison@gmail.com> writes:

> With the below patch how can I track when it has been merged into 4.13
> so I can check and start using it? For 4.14 I'm assuming I'll get an
> 'applied' email from you so I can track through git but as I've never
> had a patch go backwards into stable I'm unsure of how it works.

So if Greg applies a patch to one of stable his stable releases who
usually sends a private email to the patch author and anyone who has
signed off the patch. So you should get an email about that. You can
also follow the stable trees mentioned here:

https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

But good that you brought up this as I almost missed your patch from
this week's pull request for 4.14. I'll apply it shortly.

-- 
Kalle Valo
