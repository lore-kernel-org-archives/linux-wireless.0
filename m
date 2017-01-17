Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43458 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbdAQLHU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 06:07:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH V2] mtd: bcm47xxsflash: use platform_(set|get)_drvdata
References: <20170116162818.12094-1-zajec5@gmail.com>
Date: Tue, 17 Jan 2017 13:07:12 +0200
In-Reply-To: <20170116162818.12094-1-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Mon, 16 Jan 2017 17:28:18 +0100")
Message-ID: <87fukiosgv.fsf@codeaurora.org> (sfid-20170117_120734_095439_31F09F9E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> We have generic place & helpers for storing platform driver data so
> there is no reason for using custom priv pointer.
>
> This allows cleaning up struct bcma_sflash from unneeded fields.
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
> Kalle: This is mtd focused patch, so I guess it should go through mtd tre=
e. Do
>        you find bcma change important enough to care to Ack it? :)

Sure :)

Feel free to take the patch via mtd tree, I'm not expecting to see any
conflicts with this patch. For the bcma part:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

--=20
Kalle Valo
