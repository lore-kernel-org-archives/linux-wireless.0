Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34996 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaHDGNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 02:13:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Himangi Saraogi <himangi774@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	<ath6kl@lists.infradead.org>
Subject: Re: [PATCH] ath6kl: convert a driver to use module_usb_driver()
References: <20140801161115.GA13979@himangi-Dell>
Date: Mon, 4 Aug 2014 09:13:26 +0300
In-Reply-To: <20140801161115.GA13979@himangi-Dell> (Himangi Saraogi's message
	of "Fri, 1 Aug 2014 21:41:15 +0530")
Message-ID: <8738dc6aux.fsf@kamboji.qca.qualcomm.com> (sfid-20140804_081348_721592_11662B07)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himangi Saraogi <himangi774@gmail.com> writes:

> This converts a driver in drivers/net/* to use the
> module_usb_driver() macro which makes the code smaller and a
> bit simpler.
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Thanks, applied.

-- 
Kalle Valo
