Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51140 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3C0NF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 09:05:28 -0400
Received: by mail-ie0-f175.google.com with SMTP id c12so9999518ieb.6
        for <linux-wireless@vger.kernel.org>; Wed, 27 Mar 2013 06:05:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363905589-8350-13-git-send-email-pizza@shaftnet.org>
References: <1363905589-8350-1-git-send-email-pizza@shaftnet.org>
	<1363905589-8350-13-git-send-email-pizza@shaftnet.org>
Date: Wed, 27 Mar 2013 14:05:27 +0100
Message-ID: <CACRpkdabdiA=bQX3nCyB2jP2hDQq0SEqVXqF1myN1jswXT2e6w@mail.gmail.com> (sfid-20130327_140532_800254_CC900EE4)
Subject: Re: [PATCH 12/15] cw1200: v5: Platform definitions, plus SDIO and SPI
 bus glue code
From: Linus Walleij <linus.walleij@linaro.org>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 21, 2013 at 11:39 PM, Solomon Peachy <pizza@shaftnet.org> wrote:

>  drivers/net/wireless/cw1200/cw1200_sdio.c | 415 ++++++++++++++++++++++++++
>  drivers/net/wireless/cw1200/cw1200_spi.c  | 470 ++++++++++++++++++++++++++++++
>  include/linux/cw1200_platform.h           |  46 +++

I think platform data shall be in
include/linux/platform_data/wireless-cw1200.h these
days.

Apart from that I do not understand WLAN drivers, sorry :-)

Yours,
Linus Walleij
