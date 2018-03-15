Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:33588 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751753AbeCOLqm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 07:46:42 -0400
Received: by mail-wr0-f182.google.com with SMTP id z73so3690623wrb.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 04:46:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87vae0yox2.fsf@purkki.adurom.net>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
 <1520260620-4694-10-git-send-email-amitkarwar@gmail.com> <87vae0yox2.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 15 Mar 2018 17:16:40 +0530
Message-ID: <CAEhWJF=pWgyO3HYq9RaO_Au97jJGHyE8toNSaNnM0AN+CVSaig@mail.gmail.com> (sfid-20180315_124645_902645_D842D852)
Subject: Re: [PATCH 09/10] rsi: tx improvements
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2018 at 8:59 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> Changes done to improve TX path:
>> 1. Max number of frames to aggregate is increased to 8
>> 2. Bootup parameters updated.
>> 3. registering 5g band is done only when device supports
>> 4. Vif is properly taken to enable power save.
>> 5. When coex mode exist, power save on by default is set
>
> If you have a list of changes in the commit log to me that's a strong
> indication that you need to split the patches.
>
> Also I don't see any answers to question "Why?".

Sure. I will split into multiple incremental patches and submit with
proper commit log.

Regards,
Amitkumar
