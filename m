Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52617 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967040Ab0GSVle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 17:41:34 -0400
Received: by pwi5 with SMTP id 5so1854903pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jul 2010 14:41:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279480162-20673-1-git-send-email-hauke@hauke-m.de>
References: <1279480162-20673-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 19 Jul 2010 14:41:14 -0700
Message-ID: <AANLkTinCpwktrTgVV6QFQWJ2vKT4BH80l0kPtEFE7bv-@mail.gmail.com>
Subject: Re: [PATCH] compat: fix build if CONFIG_PCCARD=y and CONFIG_PCMCIA=n
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 18, 2010 at 12:09 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The includes are needed for pccard_loop_tuple.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks! Applied and pushed out.

  Luis
