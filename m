Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35481 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbbG2Krk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 06:47:40 -0400
Received: by wibxm9 with SMTP id xm9so195124768wib.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2015 03:47:39 -0700 (PDT)
Subject: Re: Driver for Mediatek MT7630E
To: Linus Walleij <linus.walleij@linaro.org>
References: <55B80F21.3090803@gmail.com>
 <CACRpkdYTJWS7mbw_OJtW78ThQ6jZ7aSoM5uR1SLihV4L+E5vtQ@mail.gmail.com>
Cc: Jakub Kicinski <kubakici@wp.pl>,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <55B8AF48.2040809@gmail.com> (sfid-20150729_124744_290165_42E6ABA8)
Date: Wed, 29 Jul 2015 12:47:36 +0200
MIME-Version: 1.0
In-Reply-To: <CACRpkdYTJWS7mbw_OJtW78ThQ6jZ7aSoM5uR1SLihV4L+E5vtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2015 09:38 AM, Linus Walleij wrote:

> The defines etc patched in have obvious gaps due to other unsupported
> chips such as MT7601u I suspect. I guess it's necessary to also
> look at this in order to not screw things up for 7601.
> https://github.com/porjo/mt7601

The driver for MediaTek MT7601U was recently added to upstream at:
drivers/net/wireless/mediatek/mt7601u/
