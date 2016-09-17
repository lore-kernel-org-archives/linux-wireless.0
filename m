Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44731 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752176AbcIQPOq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 11:14:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        <87eg4i8wqi.fsf@kamboji.qca.qualcomm.com>
        <1474123851.7623.2.camel@sipsolutions.net>
        <87wpia7eou.fsf@kamboji.qca.qualcomm.com>
        <1474125118.7623.3.camel@sipsolutions.net>
Date: Sat, 17 Sep 2016 18:14:40 +0300
In-Reply-To: <1474125118.7623.3.camel@sipsolutions.net> (Johannes Berg's
        message of "Sat, 17 Sep 2016 17:11:58 +0200")
Message-ID: <87oa3m7e3j.fsf@kamboji.qca.qualcomm.com> (sfid-20160917_171450_714949_D032E294)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2016-09-17 at 18:01 +0300, Kalle Valo wrote:
>>=C2=A0
>> Sorry, I was unclear. I meant the whole file
> [...]

Argh, I meant the whole driver of course, not just the file.

> Ah, ok - yeah, I think you're right - I think the supported_band ones
> can be, for example, and probably others as well.

Maybe also some of the pci related.

--=20
Kalle Valo
