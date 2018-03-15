Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:36515 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbeCOLpV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 07:45:21 -0400
Received: by mail-wr0-f178.google.com with SMTP id d10so7978902wrf.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 04:45:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87zi3cyozt.fsf@purkki.adurom.net>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
 <1520260620-4694-9-git-send-email-amitkarwar@gmail.com> <87zi3cyozt.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 15 Mar 2018 17:15:19 +0530
Message-ID: <CAEhWJF=aXfYknaTtCQqvjC3pXA1Fb81QS7UTKx4QZ6BXQpv32g@mail.gmail.com> (sfid-20180315_124526_437944_FC088A26)
Subject: Re: [PATCH 08/10] rsi: device disconnect changes
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2018 at 8:57 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> Below changes are done:
>> 1. When HCI detach is called, making bt_adapter null and checking
>> for this variable where ever required.
>> 2. In USB case, one extra register write is added to disable
>> firmware watchdog.
>> 3. When interface down is called as part of disconnect, don't
>> send RX filter frame.
>
> Why? What does this patch fix? Please explain that (symptoms) in the
> commit log.

Kindly ignore this patch. I will include proper commit log which
explains the issue and resolution in updated version.

Regards,
Amitkumar
