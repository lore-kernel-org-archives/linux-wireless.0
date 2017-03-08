Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39700 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752998AbdCHTEw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 14:04:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Simon Kelley <simon@thekelleys.org.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: wireless/atmel: remove time_t usage
References: <20170223161445.19200-1-alexandre.belloni@free-electrons.com>
        <20170308151340.9D6E360209@smtp.codeaurora.org>
        <20170308161025.nxz6puyeo3ezwa43@piout.net>
Date: Wed, 08 Mar 2017 20:53:15 +0200
In-Reply-To: <20170308161025.nxz6puyeo3ezwa43@piout.net> (Alexandre Belloni's
        message of "Wed, 8 Mar 2017 17:10:25 +0100")
Message-ID: <871su77g84.fsf@kamboji.qca.qualcomm.com> (sfid-20170308_200511_122425_F1D2788B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexandre Belloni <alexandre.belloni@free-electrons.com> writes:

> Hi,
>
> On 08/03/2017 at 15:13:40 +0000, Kalle Valo wrote:
>> Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
>> > last_qual never really holds a time. It only holds jiffies. Make it the
>> > same type as jiffies.
>> > 
>> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> 
>> The title should start with "atmel:", I can fix that during commit.
>> 
>
> If you prefer, I can send a v2

Thanks, but no need. I can easily edit the commit log when I commit it.

-- 
Kalle Valo
