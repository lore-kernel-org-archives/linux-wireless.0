Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56601 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab0JDQB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 12:01:57 -0400
Received: by iwn5 with SMTP id 5so7076167iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 09:01:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286190700-2890-1-git-send-email-senthilkumar@atheros.com>
References: <1286190700-2890-1-git-send-email-senthilkumar@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 Oct 2010 09:01:35 -0700
Message-ID: <AANLkTinaAYfnhH1kZvCwTUV3wW08TEposCQmzzo5pwnL@mail.gmail.com>
Subject: Re: [PATCH] ath9k: remove unnecessary power save flag and cleanup to code.
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 4, 2010 at 4:11 AM, Senthil Balasubramanian
<senthilkumar@atheros.com> wrote:
> drv_config callback is called only after the ack for the nullframe
> is received and so driver need not do anything special for this.
>
> So remove NULLFUNC_COMPLETED, PS_ENABLED flags and bf_isnullfunc
> flags from ath9k as mac80211 already handles them properly.
>
> Also modularize the power save config callback.
>
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>

Senthil can you split these up into two separate patches?

  Luis
