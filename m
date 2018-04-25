Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:39892 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754656AbeDYOm2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 10:42:28 -0400
Received: by mail-vk0-f47.google.com with SMTP id g83so11104116vkc.6
        for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2018 07:42:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87po2nagrk.fsf@kamboji.qca.qualcomm.com>
References: <20180424235752.GA37317@beast> <87po2nagrk.fsf@kamboji.qca.qualcomm.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 25 Apr 2018 07:42:25 -0700
Message-ID: <CAGXu5jJrd94=RQJHqfdP9wTfhsp61+aCnOmr06bia3mmi79_Mg@mail.gmail.com> (sfid-20180425_164250_653865_CE1AAE4D)
Subject: Re: [PATCH v3] ath9k: dfs: Remove VLA usage
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Andreas Christoforou <andreaschristofo@gmail.com>,
        Rosen Penev <rosenp@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Joe Perches <joe@perches.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 25, 2018 at 12:26 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> I have already applied an almost identical patch:
>
> ath9k: dfs: remove accidental use of stack VLA
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=9c27489a34548913baaaf3b2776e05d4a9389e3e

Ah! Cool, no worries. I didn't see that in linux-next yet. :)

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
