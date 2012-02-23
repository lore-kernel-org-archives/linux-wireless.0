Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33888 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2BWSKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 13:10:19 -0500
Received: by wics10 with SMTP id s10so942191wic.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 10:10:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328818149-4826-15-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
	<1328818149-4826-15-git-send-email-arend@broadcom.com>
Date: Thu, 23 Feb 2012 19:10:17 +0100
Message-ID: <CACna6rxgGuCNY19Dn=VcgUH=EORNr72x4CTbR61srSZmcM+h-w@mail.gmail.com> (sfid-20120223_191025_162926_9F36EFB4)
Subject: Re: [PATCH 14/15] brcm80211: fmac: add USB support for bcm43235/6/8 chipsets
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"M. Lambert" <lambertm@westman.wave.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/2/9 Arend van Spriel <arend@broadcom.com>:
> This patch extends the use of the brcmfmac driver with support for
> chipsets with a USB host interface. The first chipsets supported are
> the bcm43235, bcm43236, and bcm43238 for which firmware has been
> submitted.

Can you say something more about the firmware? AFAICS brcm directory
in linux-firmware.git contains:
brcmfmac43236b.bin
brcmfmac4329.bin
brcmfmac4330.bin


> +#define BRCMF_USB_FW_NAME      "brcm/brcmfmac-usb.bin"

However your driver seems to require *only* brcmfmac-usb.bin firmware file...

-- 
Rafał
