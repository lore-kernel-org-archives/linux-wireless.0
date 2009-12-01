Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33967 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZLATHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 14:07:24 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so5276182ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 11:07:30 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v3 2/4] rt2x00: Remove SKBDESC_L2_PADDED flag.
Date: Tue, 1 Dec 2009 20:07:27 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com> <1259615298-2305-2-git-send-email-gwingerde@gmail.com> <1259615298-2305-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259615298-2305-3-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912012007.28165.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 November 2009, Gertjan van Wingerde wrote:
> With the improved L2 padding code, this flag is no longer necessary, as the
> rt2x00queue_remove_l2pad is capable of detecting by itself if L2 padding is
> applied.
> For received frames the RX descriptor flag is still being checked.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c   |    5 +----
>  drivers/net/wireless/rt2x00/rt2800usb.c   |    4 +---
>  drivers/net/wireless/rt2x00/rt2x00queue.c |    6 +-----
>  drivers/net/wireless/rt2x00/rt2x00queue.h |    5 +----
>  4 files changed, 4 insertions(+), 16 deletions(-)
> 


