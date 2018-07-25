Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33582 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbeGYHuU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 03:50:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Reizer\, Eyal" <eyalr@ti.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Subject: Re: [PATCH] drivers: net: wlcore: remove duplicate \n for some warnings
References: <af660348ade58fd33396d2dca432536d2ac85cf7.1532498079.git.hns@goldelico.com>
Date: Wed, 25 Jul 2018 09:40:02 +0300
In-Reply-To: <af660348ade58fd33396d2dca432536d2ac85cf7.1532498079.git.hns@goldelico.com>
        (H. Nikolaus Schaller's message of "Wed, 25 Jul 2018 07:55:04 +0200")
Message-ID: <87lg9zyg1p.fsf@codeaurora.org> (sfid-20180725_084035_662227_C0C961D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"H. Nikolaus Schaller" <hns@goldelico.com> writes:

> wl1271_warning() already appends a \n to the format,
> so adding one to the warning string gives empty lines in the log.
>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>

"drivers: net:" in the title is unnecessary, but I can remove that.

-- 
Kalle Valo
