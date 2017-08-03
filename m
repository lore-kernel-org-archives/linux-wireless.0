Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:34655 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbdHCOez (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 10:34:55 -0400
Received: by mail-yw0-f174.google.com with SMTP id s143so9536625ywg.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 07:34:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ini648cw.fsf@codeaurora.org>
References: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com>
 <1501578352-10795-2-git-send-email-amitkarwar@gmail.com> <87ini648cw.fsf@codeaurora.org>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 3 Aug 2017 20:04:53 +0530
Message-ID: <CAEhWJFkve87KFcFzwxbLvzE-2uFW0Y-taqMcrOy7tUY9RHRRsA@mail.gmail.com> (sfid-20170803_163457_623032_BBAEA4EE)
Subject: Re: [PATCH 1/8] rsi: add support for rf-kill functionality
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        "pavani.muthyala" <pavani.muthyala@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 2, 2017 at 3:08 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: "pavani.muthyala" <pavani.muthyala@redpinesignals.com>
>>
>> This patch implements rfkill_poll handler. Also, necessary changes
>> are done in interface up and down handler to support rfkill
>> functionality.
>>
>> Signed-off-by: pavani.muthyala <pavani.muthyala@redpinesignals.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> Pavani's name in From and S-o-b fields are in incorrect format.
>

Thanks. I have corrected this in v2 patch series.

Regards,
Amitkumar Karwar
