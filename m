Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35763 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab0GTScv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 14:32:51 -0400
Received: by bwz1 with SMTP id 1so3091403bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 11:32:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279650227-11089-1-git-send-email-linville@tuxdriver.com>
References: <1279650227-11089-1-git-send-email-linville@tuxdriver.com>
Date: Tue, 20 Jul 2010 20:32:49 +0200
Message-ID: <AANLkTilquNPpXk9UWLoMSSbUMZpDKNWiARjMk1RpuVj2@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: correct sparse warning in rt2x00debug.c
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, gwingerde@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 20, 2010 at 8:23 PM, John W. Linville
<linville@tuxdriver.com> wrote:
>  CHECK   drivers/net/wireless/rt2x00/rt2x00debug.c
> drivers/net/wireless/rt2x00/rt2x00debug.c:193:28: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/rt2x00/rt2x00debug.c:193:28:    expected restricted __le32 [usertype] chip_rev
> drivers/net/wireless/rt2x00/rt2x00debug.c:193:28:    got restricted __le16 [usertype] <noident>
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks.
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dump.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dump.h b/drivers/net/wireless/rt2x00/rt2x00dump.h
> index 6df2e0b..5d6e0b8 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dump.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00dump.h
> @@ -116,7 +116,7 @@ struct rt2x00dump_hdr {
>
>        __le16 chip_rt;
>        __le16 chip_rf;
> -       __le32 chip_rev;
> +       __le16 chip_rev;
>
>        __le16 type;
>        __u8 queue_index;
> --
> 1.7.1.1
>
>
