Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38090 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbeCLJlP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 05:41:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/3] mwifiex: support sysfs initiated device coredump
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519210220-22437-3-git-send-email-arend.vanspriel@broadcom.com>
References: <1519210220-22437-3-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180312094115.1996760452@smtp.codeaurora.org> (sfid-20180312_104211_530181_DD750804)
Date: Mon, 12 Mar 2018 09:41:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
> it is possible to initiate a device coredump from user-space. This
> patch adds support for it adding the .coredump() driver callback.
> As there is no longer a need to initiate it through debugfs remove
> that code.
> 
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Based on the discussion I assume this is ok to take to w-d-next. If that's not
the case, please let me know ASAP.

-- 
https://patchwork.kernel.org/patch/10231933/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
