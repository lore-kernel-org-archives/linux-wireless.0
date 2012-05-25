Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58798 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423Ab2EYAv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 20:51:59 -0400
Received: by obbtb18 with SMTP id tb18so482428obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2012 17:51:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337866168-11749-1-git-send-email-nbd@openwrt.org>
References: <1337866168-11749-1-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Thu, 24 May 2012 17:51:37 -0700
Message-ID: <CAB=NE6WzN3wv=n_+oX+EQhvuNKg6mH-wavEygpDS+pbKouVA3A@mail.gmail.com> (sfid-20120525_025208_639273_8C5C0F2A)
Subject: Re: [PATCH] compat: rename compat-3.5.c to compat-3.4.c
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 24, 2012 at 6:29 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> It only contains simple_open, which is already available on Linux 3.4.
> Fixes duplicate symbol issues on 3.4
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks! The equivalent change was required from
include/linux/compat-3.5.h to include/linux/compat-3.4.h, I took care
of that though, merged and I'll push this shortly!

  Luis
