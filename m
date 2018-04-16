Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:40686 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbeDPWYZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 18:24:25 -0400
Received: by mail-qk0-f195.google.com with SMTP id o64so18366467qkl.7
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 15:24:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180416131634.25432-1-daniel@zonque.org>
References: <20180416131634.25432-1-daniel@zonque.org>
From: Ramon Fried <ramon.fried@linaro.org>
Date: Tue, 17 Apr 2018 01:24:24 +0300
Message-ID: <CAODu4Nqkqyxh7AXs6zCRKxc1LaxPoBsjEdnBsyZHi70p_u7RDQ@mail.gmail.com> (sfid-20180417_002429_241409_3396AA82)
Subject: Re: [PATCH 0/5] wcn36xx: scan related patches
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        kvalo@codeaurora.org, Loic Poulain <loic.poulain@linaro.org>,
        Ramon Fried <rfried@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 April 2018 at 16:16, Daniel Mack <daniel@zonque.org> wrote:
> Here's another series of 5 patches for wcn36xx that address some issues
> with scanning. The first one is the most important one.
>
Nicely done. Thanks !
>
> Daniel
>
> Daniel Mack (5):
>   wcn36xx: abort scan request when 'dequeued' indicator is sent
>   wcn36xx: cancel pending scan request when interface goes down
>   wcn36xx: handle scan cancellation when firmware support is missing
>   wcn36xx: send bss_type in scan requests
>   wcn36xx: pass information elements in scan requests
>
>  drivers/net/wireless/ath/wcn36xx/hal.h     |  8 +++++++-
>  drivers/net/wireless/ath/wcn36xx/main.c    | 29 +++++++++++++++++++++++++----
>  drivers/net/wireless/ath/wcn36xx/smd.c     | 20 +++++++++++++++++---
>  drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  7 +------
>  4 files changed, 50 insertions(+), 14 deletions(-)
>
> --
> 2.14.3
>
