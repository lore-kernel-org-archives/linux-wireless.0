Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41291 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab0HJBSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Aug 2010 21:18:34 -0400
Received: by iwn33 with SMTP id 33so4010648iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Aug 2010 18:18:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>
References: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 9 Aug 2010 18:18:13 -0700
Message-ID: <AANLkTi=6DY=N23HSYrMrZox+yLZpv82ki_VLBxA1uhq4@mail.gmail.com>
Subject: Re: [PATCH 0/4] compat: miscellaneous updates for compat
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 7, 2010 at 6:32 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This series contains miscellaneous updates for compat. They are compile
> tested with kernel 2.6.26 to 2.6.35. ath9k and b43 were tested with
> kernel 2.6.32.
>
> Hauke Mehrtens (4):
>  compat: backport n_tty_ioctl_helper
>  compat: move va_format to compat-2.6.36.h
>  compat: fix compiler warning
>  compat: update compat_firmware_class.c
>
>  compat/compat-2.6.28.c         |  128 ++++++++++++++++++
>  compat/compat_firmware_class.c |  290 ++++++++++++++++++++-------------------
>  include/linux/compat-2.6.27.h  |    2 +
>  include/linux/compat-2.6.28.h  |    6 +
>  include/linux/compat-2.6.35.h  |    5 -
>  include/linux/compat-2.6.36.h  |    5 +
>  6 files changed, 290 insertions(+), 146 deletions(-)

Nice, thanks applied all 4 patches to compat and the 2 other patches
to compat-wireless. Sorry for the delay.

  Luis
