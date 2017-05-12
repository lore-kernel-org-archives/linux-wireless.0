Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbdELFFa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 01:05:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: amit karwar <amitkarwar@gmail.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] rsi: Rename the file rsi_91x_pkt.c to rsi_91x_hal.c
References: <1491282009-2854-1-git-send-email-prameela.j04cs@gmail.com>
        <CAEhWJFnf3ofgQo4POORaF1-0fHvaSTdJk27HyauMrnbGcfn+zg@mail.gmail.com>
Date: Fri, 12 May 2017 08:05:26 +0300
In-Reply-To: <CAEhWJFnf3ofgQo4POORaF1-0fHvaSTdJk27HyauMrnbGcfn+zg@mail.gmail.com>
        (amit karwar's message of "Tue, 9 May 2017 19:07:03 +0530")
Message-ID: <8737casm09.fsf@kamboji.qca.qualcomm.com> (sfid-20170512_070535_214617_2F0844EA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

amit karwar <amitkarwar@gmail.com> writes:

> On Tue, Apr 4, 2017 at 10:30 AM, Prameela Rani Garnepudi
> <prameela.j04cs@gmail.com> wrote:
>> The file rsi_91x_hal.c will contain new firmware loading method for
>> RSI 9113 chipset. So this file will have device specific operations.
>> As the file 'rsi_91x_pkt.c' contains code for preparing device
>> (frimware understandable) specific descriptors for the transmit frames,
>> it is moved to 'rsi_91x_hal.c'
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

[...]

> Kindly ignore this patch series.
> We have split the work and submitted updated version.

Ok, dropped.

-- 
Kalle Valo
