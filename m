Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:43493 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763782AbdJQTr2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 15:47:28 -0400
Received: by mail-io0-f170.google.com with SMTP id 134so3568915ioo.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Oct 2017 12:47:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mv4pvowa.fsf@purkki.adurom.net>
References: <1508200182-104605-1-git-send-email-keescook@chromium.org> <87mv4pvowa.fsf@purkki.adurom.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 17 Oct 2017 12:47:26 -0700
Message-ID: <CAGXu5j+fcARk=yWh9Bbkn0C-4PHd+pKSPGV+5qPx88H6prvUoA@mail.gmail.com> (sfid-20171017_214741_464637_6678AF0D)
Subject: Re: [PATCH 00/58] networking: Convert timers to use timer_setup()
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 17, 2017 at 7:18 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> + linux-wireless
>
> Hi Kees,
>
> Kees Cook <keescook@chromium.org> writes:
>
>> This is the current set of outstanding networking patches to perform
>> conversions to the new timer interface (rebased to -next). This is not
>> all expected conversions, but it contains everything needed in networking
>> to eliminate init_timer(), and all the non-standard setup_*_timer() uses.
>
> So this also includes patches which I had queued for
> wireless-drivers-next:
>
> https://patchwork.kernel.org/patch/9986253/
> https://patchwork.kernel.org/patch/9986245/
>
> And looking at patchwork[1] I have even more timer_setup() related
> patches from you. It would be really helpful if you could clearly
> document to which tree you want the patches to be applied. I don't care

Hi! Sorry about that. It's been a bit tricky to juggle everything.

> if it's net-next or wireless-drivers-next as long as it's not the both
> (meaning that both Dave and me apply the same patch, which would be
> bad). The thing is that I really do not have time to figure out for
> every patch via which tree it's supposed to go.

Which split is preferred? I had been trying to separate wireless from
the rest of net (but missed some cases).

> For now I'll just drop all your timer_setup() related patches from my
> queue and I'll assume Dave will take those. Ok?
>
> [1] https://patchwork.kernel.org/project/linux-wireless/list/

I guess I'll wait to see what Dave says.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
