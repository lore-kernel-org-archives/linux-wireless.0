Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35327 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbcAXUV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2016 15:21:58 -0500
Received: by mail-lf0-f45.google.com with SMTP id c192so73472478lfe.2
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2016 12:21:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1453638906-19648-1-git-send-email-hubert.tarasiuk@gmail.com>
References: <1453638906-19648-1-git-send-email-hubert.tarasiuk@gmail.com>
Date: Sun, 24 Jan 2016 22:21:56 +0200
Message-ID: <CANUX_P2E2sdiAbyBOqyY1yW89YN0gmiDCXkG2XTMdUjeYacrew@mail.gmail.com> (sfid-20160124_212201_492917_E063BA7E)
Subject: Re: [PATCH] iwlwifi: dvm: handle zero brightness for wifi LED
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 24, 2016 at 2:35 PM, Hubert Tarasiuk
<hubert.tarasiuk@gmail.com> wrote:
> This fixes bug 110551 with regard to sysfs.
>
> Misleading behaviour when 'led_mode=3' is passed to iwlwifi is still
> to be fixed (either by changing the option description or by making
> the LED permanently dark in such case).
>
> Signed-off-by: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
> ---
>  drivers/net/wireless/iwlwifi/dvm/led.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

I picked it up and will push it out soon.
