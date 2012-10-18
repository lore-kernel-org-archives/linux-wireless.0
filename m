Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35836 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068Ab2JRM4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 08:56:12 -0400
Message-ID: <507FFC5D.7010108@hauke-m.de> (sfid-20121018_145616_345053_BC13915A)
Date: Thu, 18 Oct 2012 14:55:57 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 4/5] brcmfmac: Add 43143 USB support.
References: <1346348582-20095-1-git-send-email-arend@broadcom.com> <1346348582-20095-5-git-send-email-arend@broadcom.com>
In-Reply-To: <1346348582-20095-5-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2012 07:43 PM, Arend van Spriel wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
> 
> Added usb device id to list of supported devices. 43143 is a new
> 802.11n single stream device.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  
> +#define BRCMF_USB_43143_FW_NAME	"brcm/brcmfmac43143.bin"
>  #define BRCMF_USB_43236_FW_NAME	"brcm/brcmfmac43236b.bin"
>  #define BRCMF_USB_43242_FW_NAME	"brcm/brcmfmac43242a.bin"
>  

Hi,

when do you release the firmware for this devices to the public? I can
not find it in linux-firmware or with a quick google search. I haven't
found the brcmfmac43242a.bin firmware either.

Hauke
