Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49594 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2HNB3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 21:29:22 -0400
Received: by yenl14 with SMTP id l14so2716919yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2012 18:29:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344887941-18365-1-git-send-email-hauke@hauke-m.de>
References: <1344887941-18365-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Aug 2012 18:29:01 -0700
Message-ID: <CAB=NE6WFr0X1+d=e=CYSGfMvAk6pbCqrcBfbjJtpV_zQV608gw@mail.gmail.com> (sfid-20120814_032925_805819_8CEE1505)
Subject: Re: [PATCH] compat: add tty_{un}lock() for kernel < 3.7
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2012 at 12:59 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The change of tty_{un}lock() in kernel 3.5 was reverted, but now it was
> added again for kernel 3.7.
>
> This patch does the needed changes to backport this commit:
> commit 89c8d91e31f267703e365593f6bfebb9f6d2ad01
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Wed Aug 8 16:30:13 2012 +0100
>
>     tty: localise the lock
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, and pushed, thanks so much!

  Luis
