Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49429 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab0FYEJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 00:09:58 -0400
Received: by pwj8 with SMTP id 8so2160670pwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 21:09:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277413205-6753-2-git-send-email-hauke@hauke-m.de>
References: <1277413205-6753-1-git-send-email-hauke@hauke-m.de>
	<1277413205-6753-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 24 Jun 2010 21:09:37 -0700
Message-ID: <AANLkTinFxTQyuJI7goBWCJqKRfA-L_W-ouZ3QoX01F1_@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: activate iwmc3200wifi and
	WL1271_SDIO
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 24, 2010 at 2:00 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> netdev_ops for iwmc3200wifi is backported now.
> CONFIG_WL1271_SDIO does not depend on ARM any more in mainline, but it
> needs at least kernel 2.6.32.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks!! Applied both patches.

  Luis
