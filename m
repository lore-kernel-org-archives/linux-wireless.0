Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63027 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0FMUZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 16:25:41 -0400
Received: by pwi1 with SMTP id 1so2260293pwi.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 13:25:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1276459009-17168-2-git-send-email-hauke@hauke-m.de>
References: <1276459009-17168-1-git-send-email-hauke@hauke-m.de>
	<1276459009-17168-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 13 Jun 2010 13:25:21 -0700
Message-ID: <AANLkTil4XIVT2vuQwDWFsCjKX2sIo3ac6MTe_UoFvQlS@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat: backport sdio_writeb_readb
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 13, 2010 at 12:56 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This is needed by wl1251_sdio.c
> Use sdio_readb instead of sdio_writeb_readb as long as sdio_writeb_readb was not realy backported.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied both!

  Luis
