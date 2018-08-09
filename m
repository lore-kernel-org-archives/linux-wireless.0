Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49794 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730880AbeHISQO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 14:16:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Joe Perches <joe@perches.com>
Subject: Re: ssb: Remove home-grown printk wrappers
References: <20180731215638.381f0370@wiggum>
        <877ekz1r1d.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 09 Aug 2018 18:50:40 +0300
In-Reply-To: <877ekz1r1d.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Thu, 09 Aug 2018 18:46:38 +0300")
Message-ID: <87y3dfzghb.fsf@kamboji.qca.qualcomm.com> (sfid-20180809_175047_532767_0FD0A2DD)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Michael B=C3=BCsch <m@bues.ch> writes:
>
>> Replace the ssb printk wrappers by standard print helpers.
>> Also remove SSB_SILENT. Nobody should use it anyway.
>>
>> Originally submitted by Joe Perches <joe@perches.com>.
>> Modified to add dev_... based printks.
>>
>> Signed-off-by: Michael Buesch <m@bues.ch>
>> Tested-by: Michael Buesch <m@bues.ch>
>> Cc: Joe Perches <joe@perches.com>
>
> Applied manually:
>
> 4d77a89e3924 b43legacy/leds: Ensure NUL-termination of LED name string

Heh, a copy paste error. Shows that I should not be applying anything
manually. Anyway, the correct commit id is:

b8b6069cf208 ssb: Remove home-grown printk wrappers

--=20
Kalle Valo
