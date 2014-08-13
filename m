Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54061 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaHMNg7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 09:36:59 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Simon Kelley <simon@thekelleys.org.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] drivers/net/wireless: Remove typedef local_info_t
References: <20140813091713.GA2995@himangi-Dell>
Date: Wed, 13 Aug 2014 15:59:49 +0300
In-Reply-To: <20140813091713.GA2995@himangi-Dell> (Himangi Saraogi's message
	of "Wed, 13 Aug 2014 14:47:13 +0530")
Message-ID: <87egwka6ka.fsf@purkki.adurom.net> (sfid-20140813_153702_319610_E832D5D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himangi Saraogi <himangi774@gmail.com> writes:

> The Linux kernel coding style guidelines suggest not using typedefs
> for structure types. This patch gets rid of the typedef for
> local_info_t. Also, the name of the struct is changed to drop the _t,
> to make the name look less typedef-like.

[...]

>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  drivers/net/wireless/atmel_cs.c | 22 +++++++++++-----------

You should prefix the patch with "atmel_cs:", not
"drivers/net/wireless".

-- 
Kalle Valo
