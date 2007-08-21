Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:22314 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbXHUQcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 12:32:12 -0400
Received: by py-out-1112.google.com with SMTP id u77so2661167pyb
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2007 09:32:11 -0700 (PDT)
Message-ID: <43e72e890708210932j7684d6c4h8dfe0193f67f1e8f@mail.gmail.com>
Date: Tue, 21 Aug 2007 12:32:11 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mark islsm list as subscribers-only
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1187282653.23489.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1187282653.23489.36.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/16/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> This is bordering on stupid. I just received a bounce from it because
> I'm not subscribed:
>
> ---begin mail---
> Sorry, this list is for subscribers only. We previously held incoming
> mail by non-subscribers for manual approval, but due to the increase
> in spam this is no longer feasible.
>
> If you are seriously attempting to send mail to the islsm developers
> list, please subscribe to the list and re-send.
> ---end mail---
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
> ---
> Or just remove it from MAINTAINERS as it obviously doesn't want mail.
>
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- wireless-dev.orig/MAINTAINERS       2007-08-16 18:38:11.713468950 +0200
> +++ wireless-dev/MAINTAINERS    2007-08-16 18:42:49.783468950 +0200
> @@ -3037,7 +3037,7 @@ P54 WIRELESS DRIVER
>  P:     Michael Wu
>  M:     flamingice@sourmilk.net
>  L:     linux-wireless@vger.kernel.org
> -L:     developers@islsm.org
> +L:     developers@islsm.org (subscribers-only; drops mail but spams you)
>  W:     http://prism54.org
>  T:     git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
>  S:     Maintained
>

I think that list was for the net80211 driver, not even sure if its
used actively for the mac80211 driver.

  Luis
