Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34299 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbdBHTc1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 14:32:27 -0500
Received: by mail-it0-f66.google.com with SMTP id o185so16478938itb.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2017 11:30:39 -0800 (PST)
Date: Wed, 8 Feb 2017 11:21:42 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V2] mtd: bcm47xxsflash: use platform_(set|get)_drvdata
Message-ID: <20170208192142.GA94627@google.com> (sfid-20170208_203331_221040_70B0939D)
References: <20170116162818.12094-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170116162818.12094-1-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2017 at 05:28:18PM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> We have generic place & helpers for storing platform driver data so
> there is no reason for using custom priv pointer.
> 
> This allows cleaning up struct bcma_sflash from unneeded fields.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> Kalle: This is mtd focused patch, so I guess it should go through mtd tree. Do
>        you find bcma change important enough to care to Ack it? :)

Applied to l2-mtd.git.
