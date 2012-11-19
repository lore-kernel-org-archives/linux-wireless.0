Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2963 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab2KSRka (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 12:40:30 -0500
Message-ID: <50AA6EF4.5080304@broadcom.com> (sfid-20121119_184036_388749_D833351F)
Date: Mon, 19 Nov 2012 18:40:04 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Fengguang Wu" <fengguang.wu@intel.com>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: Re: [PATCH] brcmfmac: include linux/vmalloc.h from usb.c
References: <1353341068-24532-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1353341068-24532-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2012 05:04 PM, John W. Linville wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
>
> This avoids build failures on some architectures...
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/usb.c | 1 +
>   1 file changed, 1 insertion(+)
>

Acked-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS


