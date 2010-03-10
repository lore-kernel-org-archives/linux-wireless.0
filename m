Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53236 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab0CJXxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 18:53:33 -0500
Received: by pwj5 with SMTP id 5so537699pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Mar 2010 15:53:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1268213691-2497-1-git-send-email-senthilkumar@atheros.com>
References: <1268213691-2497-1-git-send-email-senthilkumar@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 10 Mar 2010 15:53:12 -0800
Message-ID: <43e72e891003101553i339dbeb7keb6fa4cc69c16c84@mail.gmail.com>
Subject: Re: [PATCH 1/3] Support for AR9271 chipset.
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 10, 2010 at 1:34 AM, Senthil Balasubramanian
<senthilkumar@atheros.com> wrote:
> From: Sujith <Sujith.Manoharan@atheros.com>
>
> Features:
>
>  * Station mode
>  * IBSS mode
>  * Monitor mode
>  * Legacy support
>  * HT support
>  * TX/RX 11n Aggregation
>  * HW encryption
>  * LED
>
> For more information: http://wireless.kernel.org/en/users/Drivers/ath9k_htc
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>

The common stuff was stuffed into common.[ch] but yet ath9k was not
made to use it. That is fine if it makes this easier for inclusion
into 2.6.34, if it won't get into 2.6.34 I'd prefer that a separate
patch be created to stuff the common stuff into common.[ch], make
ath9k use it, and then make ath9k_htc use it, through this patch.

John can decide :D

  Luis
