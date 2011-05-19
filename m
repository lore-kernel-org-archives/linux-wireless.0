Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36054 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab1ESVUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 17:20:04 -0400
Received: by iyb14 with SMTP id 14so2432867iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 14:20:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305395252-21873-1-git-send-email-hauke@hauke-m.de>
References: <1305395252-21873-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 19 May 2011 14:19:44 -0700
Message-ID: <BANLkTin=FddRF8xMUNJCwg1efpDZGRad0Q@mail.gmail.com> (sfid-20110519_232009_159476_F8E80B52)
Subject: Re: [PATCH] compat: add header linux/printk.h
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 14, 2011 at 10:47 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Some drivers are including linux/printk.h and this is not available for
> kernel < 2.6.37, but the needed declared methods are all in
> linux/kernel.h.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, thanks!

  Luis
