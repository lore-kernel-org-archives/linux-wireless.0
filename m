Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59616 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbeGaJCg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:02:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] wlcore: remove duplicate \n for some warnings
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <af660348ade58fd33396d2dca432536d2ac85cf7.1532498079.git.hns@goldelico.com>
References: <af660348ade58fd33396d2dca432536d2ac85cf7.1532498079.git.hns@goldelico.com>
To: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Reizer, Eyal" <eyalr@ti.com>,
        Kees Cook <keescook@chromium.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Message-Id: <20180731072340.A3926606AC@smtp.codeaurora.org> (sfid-20180731_092412_957250_7A027358)
Date: Tue, 31 Jul 2018 07:23:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"H. Nikolaus Schaller" <hns@goldelico.com> wrote:

> wl1271_warning() already appends a \n to the format,
> so adding one to the warning string gives empty lines in the log.
> 
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>

Patch applied to wireless-drivers-next.git, thanks.

18dc5a4bbcc5 wlcore: remove duplicate \n for some warnings

-- 
https://patchwork.kernel.org/patch/10543473/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
