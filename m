Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:33331 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbdEPKJ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:09:29 -0400
Received: by mail-qt0-f177.google.com with SMTP id t26so113941307qtg.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 03:09:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lgq2qx8a.fsf@kamboji.qca.qualcomm.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
 <1494336614-2107-11-git-send-email-amit.karwar@redpinesignals.com> <87lgq2qx8a.fsf@kamboji.qca.qualcomm.com>
From: amit karwar <amitkarwar@gmail.com>
Date: Tue, 16 May 2017 15:39:28 +0530
Message-ID: <CAEhWJFnGA8iUpCs+CfZNVP6OTdpoMCOV8_bPkjy=0j0m4b6PLw@mail.gmail.com> (sfid-20170516_120933_326926_7BA10E2A)
Subject: Re: [v2 10/11] rsi: Add new firmware loading method
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 12, 2017 at 2:15 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> The older firmware loading method has been deprecated and not in use
>> for any chipets. New method is introduced which works based on soft
>> boot loader. In this method, complete RAM image and FLASH image are
>> present in the flash. Before loading the functional firmware, host
>> issues boot loader commands to verify whether firmware to load is
>> different from the current functional firmware. If not, firmware
>> upgrade progresses and boot loader will switch to the new functional
>> firmware.
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> Please document in the commit log the new firmware filenames used by
> this patch.
>

Sure. This has been taken care in updated version.

Regards,
Amitkumar
