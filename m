Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:39786 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934256AbZJMUMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 16:12:54 -0400
Received: by iwn10 with SMTP id 10so2969478iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 13:12:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 13 Oct 2009 13:11:58 -0700
Message-ID: <43e72e890910131311i2a3df2dh8af07ebd4456885@mail.gmail.com>
Subject: Re: [PATCH 0/10] [compat-2.6 and compat-stable] Mostly build fixes
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 12, 2009 at 2:19 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This patch series is for compat-2.6 and compat-stable-2.6.32. I have
> compiled compat-wireless against mainline kernel 2.6.25 to 2.6.32. This
> was all done with Ubuntu 9.04. compat-wireless should still compile with
> openSuse, but I have not tried it.
>
> The compat-stable fixes are addressing some compile problems with older
> kernel versions. I have not tested all supported kernels.
>
> The last stable kernel was added later so the number does not match.

Thanks -- I've applied all these patches to bleeding edge, will apply
the stable patches to stable now. I was doubtful of propagating the
iw_handler changes to stable compat-wireless releases but your patch
clarifies we should otherwise we end up sending incorrect data.

  Luis
