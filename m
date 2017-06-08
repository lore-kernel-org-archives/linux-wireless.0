Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:36163 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdFHO6N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 10:58:13 -0400
MIME-Version: 1.0
In-Reply-To: <1496916183-4097-1-git-send-email-binoy.jayan@linaro.org>
References: <1496916183-4097-1-git-send-email-binoy.jayan@linaro.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 8 Jun 2017 16:58:12 +0200
Message-ID: <CAK8P3a2kJbXX8ROBgqyQDpwpKZPm_rNWW_oOAjOJyM7C-DZTiw@mail.gmail.com> (sfid-20170608_165842_535943_508B0AB4)
Subject: Re: [PATCH] mwifiex: Replace semaphore async_sem with mutex
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rajendra <rnayak@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 8, 2017 at 12:03 PM, Binoy Jayan <binoy.jayan@linaro.org> wrote:
> The semaphore 'async_sem' is used as a simple mutex, so
> it should be written as one. Semaphores are going away in the future.
>
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
> ---
>
> This patch is part of a bigger effort to eliminate unwanted
> semaphores from the linux kernel.

Looks good,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
