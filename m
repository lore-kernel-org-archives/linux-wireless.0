Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49532 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1CNSGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 14:06:20 -0400
Received: by iyb26 with SMTP id 26so5190726iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 11:06:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 14 Mar 2011 11:06:00 -0700
Message-ID: <AANLkTin+pC127zgLcy7hx-KXOkKwu8hLg92h7+mdFfix@mail.gmail.com>
Subject: Re: [PATCH 00/38] ath6kl: remove typedefs part II
To: gregkh@suse.de
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	vmehta@atheros.com, naveen.singh@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 14, 2011 at 10:58 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Greg, here is my second cleanup series for ath6kl. This series addresses
> more typedef removals. Given that I have so many and they all do the
> same, and are tested I'm submitting them all in one series. I can really
> split it but you can just do that yourself if you believe this is really
> necessary. Either way they all go tested.
>
> We still have some more typedefs left after this so that'll go in some
> other series. This applies on top of Ilia Mirkin's submitted but not
> yet merged patch titled, "staging: ath6kl: Remove NULL check before kfree"

FYI - the linux-wireless mailing list rejected a few patches so I had
to resend them, but they go unchanged. If you see a patch twice just
ignore the duplicate.

  Luis
