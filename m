Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44393 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbZCZBX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 21:23:26 -0400
Received: by fxm2 with SMTP id 2so329758fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 18:23:24 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: [PATCH 2/2 v2] p54spi: fix p54spi_upload_firmware
Date: Thu, 26 Mar 2009 04:15:26 +0300
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <73aaf0dd0903250500g51494e04iab9382e23d44f695@mail.gmail.com> <200903251345.01608.chunkeey@web.de>
In-Reply-To: <200903251345.01608.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903260415.26646.jcmvbkbc@gmail.com> (sfid-20090326_022329_540191_827F0A4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > what do you think about the attached proposal?
> >
> > It looks generally better. But (fw + offset) wouldn't compile, because
> > fw is void*.
>
> ??? but it does compile?!
>   CHECK   drivers/net/wireless/p54/p54spi.c
>   CC [M]  drivers/net/wireless/p54/p54spi.o
>  Building modules, stage 2.
>   MODPOST 4 modules
>   CC      drivers/net/wireless/p54/p54spi.mod.o
>   LD [M]  drivers/net/wireless/p54/p54spi.ko
>
> But yes, I agree we better change void *fw to u8 *fw.
>
> BTW: does p54spi really work now?
Now firmware uploading code works fine. It even successfully uploads firmware 
in small chunks.

-- 
Thanks.
-- Max
