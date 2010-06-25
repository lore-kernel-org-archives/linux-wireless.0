Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64216 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab0FYEIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 00:08:37 -0400
Received: by pwj8 with SMTP id 8so2160228pwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 21:08:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277413163-6718-1-git-send-email-hauke@hauke-m.de>
References: <1277413163-6718-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 24 Jun 2010 21:08:17 -0700
Message-ID: <AANLkTiktGRVY9eVuiKoC8drtE0X9GN5OjXhrC0zXHliH@mail.gmail.com>
Subject: Re: [PATCH] compat: backport skb_queue_splice_init
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 24, 2010 at 1:59 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This is needed by iwmc3200wifi.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, thanks!

  Luis
