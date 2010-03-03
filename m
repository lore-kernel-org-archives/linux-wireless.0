Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57379 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0CCQu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 11:50:29 -0500
Received: by gwb15 with SMTP id 15so762372gwb.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 08:50:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003031742.55842.helmut.schaa@googlemail.com>
References: <201003031742.55842.helmut.schaa@googlemail.com>
Date: Wed, 3 Mar 2010 17:50:27 +0100
Message-ID: <14add3d11003030850j2c16a92dsfad2a4a43c4d126c@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Export rt2x00soc_probe from rt2x00soc
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 3, 2010 at 5:42 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Export rt2x00soc_probe from rt2x00soc as it is used in rt2800pci.
>
> Otherwise loading rt2800pci gives "rt2800pci: Unknown symbol
> rt2x00soc_probe".
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

Thanks for doing this. I couldn't test these configurations as I am
lacking SoC devices.

John, another one for wireless-2.6.

>
> This time without whitespace damage and a suitable subject.
>
>  drivers/net/wireless/rt2x00/rt2x00soc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.c b/drivers/net/wireless/rt2x00/rt2x00soc.c
> index 4efdc96..111c0ff 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00soc.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00soc.c
> @@ -112,6 +112,7 @@ exit_free_device:
>
>        return retval;
>  }
> +EXPORT_SYMBOL_GPL(rt2x00soc_probe);
>
>  int rt2x00soc_remove(struct platform_device *pdev)
>  {
> --
> 1.6.0.2
>
>
