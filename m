Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:51012 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0DZIWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 04:22:00 -0400
Received: by ewy20 with SMTP id 20so3552277ewy.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 01:21:59 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH] rt2x00: fix typo in rt2800.h
Date: Mon, 26 Apr 2010 10:21:57 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
References: <201004261018.08830.helmut.schaa@googlemail.com>
In-Reply-To: <201004261018.08830.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201004261021.57393.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 April 2010, Helmut Schaa wrote:
> Fix a typo in a comment in rt2800.h. Instead of replacing the wrong
> hexvalue (0x171c) with the correct one (0x1718) just use the appropriate
> readable define.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index ec89372..3492825 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -107,7 +107,7 @@
>  /*
>   * INT_SOURCE_CSR: Interrupt source register.
>   * Write one to clear corresponding bit.
> - * TX_FIFO_STATUS: FIFO Statistics is full, sw should read 0x171c
> + * TX_FIFO_STATUS: FIFO Statistics is full, sw should read TX_STA_FIFO
>   */
>  #define INT_SOURCE_CSR			0x0200
>  #define INT_SOURCE_CSR_RXDELAYINT	FIELD32(0x00000001)


