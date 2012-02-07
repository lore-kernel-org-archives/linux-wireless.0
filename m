Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60683 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab2BGMvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 07:51:24 -0500
Received: by vbjk17 with SMTP id k17so4572126vbj.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 04:51:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328568313-26267-4-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-2-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-3-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-4-git-send-email-gwingerde@gmail.com>
Date: Tue, 7 Feb 2012 13:51:23 +0100
Message-ID: <CAOZOX0Xd1N-UJLwKLbu0NDc1MWs2AREeOZf3XajGXQo7pEV+Yw@mail.gmail.com> (sfid-20120207_135127_181349_7D3CF176)
Subject: Re: [PATCH 3/8] rt2x00: Update comment on freq_offset field in struct rt2x00_dev.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 11:45 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> The comment states that the field is only used for rt61pci and rt73usb.
> However, it is now used by rt2800pci and rt2800usb as well, so the
> comment is not correct anymore.
>
> Update the comment to not state any low-level drivers anymore.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 5bd2f22..ed2ae6e 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -892,7 +892,7 @@ struct rt2x00_dev {
>        u8 rssi_offset;
>
>        /*
> -        * Frequency offset (for rt61pci & rt73usb).
> +        * Frequency offset.
>         */
>        u8 freq_offset;
>
> --
> 1.7.9
>
