Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60216 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2AWRbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 12:31:35 -0500
Received: by iacb35 with SMTP id b35so4012456iac.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jan 2012 09:31:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327153475-28081-1-git-send-email-hauke@hauke-m.de>
References: <1327153475-28081-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 Jan 2012 09:31:14 -0800
Message-ID: <CAB=NE6UBBRg53EjW3t8YEUoGLvQS00dnx6Z=-rmBa7pb-D_TCg@mail.gmail.com> (sfid-20120123_183138_995095_5F8B8D06)
Subject: Re: [PATCH] compat: add __cancel_delayed_work()
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 21, 2012 at 5:44 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> __cancel_delayed_work is needed by include/net/bluetooth/l2cap.h and
> not available in old kernel versions. This was just copied from the
> kernel.
>
> This should also go into compat-wireless-stable-3.3.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks! Applied all onto compat-wireless.git and compat.git, in
addition to the linux-3.3.y branch for compat.git as you indicated for
this patch. Will roll out a new tarball right away.

  Luis
