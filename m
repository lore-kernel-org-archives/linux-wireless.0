Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48289 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1B1Ftv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 00:49:51 -0500
Received: by iyb26 with SMTP id 26so2599374iyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 21:49:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298814584-11779-1-git-send-email-hauke@hauke-m.de>
References: <1298814584-11779-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 27 Feb 2011 21:49:31 -0800
Message-ID: <AANLkTikvLy06Dt=9AVn+6ycqPAg48QNn9mW5LEkucRkJ@mail.gmail.com>
Subject: Re: [PATCH] compat: add tty_set_termios only for kernel >= 2.6.27
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 27, 2011 at 5:49 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> tty_set_termios does not build with older kernel versions and is only
> needed by bluetooth which works only for kernel >= 2.6.27.
>
> Reported-by: Juan Carlos Garza <juancarlosgarza@gmail.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, thanks!

  Luis
