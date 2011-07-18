Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4387 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab1GRKnW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 06:43:22 -0400
Message-ID: <4E240E32.2020109@broadcom.com> (sfid-20110718_124325_640509_4285A7F9)
Date: Mon, 18 Jul 2011 12:42:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "mcgrof@gmail.com" <mcgrof@gmail.com>,
	"lrodriguez@atheros.com" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] compat-wireless: deactivate sido suspend for
 brcmfmac on older kernels.
References: <1310936250-10224-1-git-send-email-hauke@hauke-m.de>
 <1310936250-10224-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1310936250-10224-2-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/17/2011 10:57 PM, Hauke Mehrtens wrote:
> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
> ---
>   patches/29-sdio_no_suspend.patch |   38 ++++++++++++++++++++++++++++++++++++++
>   1 files changed, 38 insertions(+), 0 deletions(-)
>
> diff --git a/patches/29-sdio_no_suspend.patch b/patches/29-sdio_no_suspend.patch
> index d6a6713..e940745 100644
> --- a/patches/29-sdio_no_suspend.patch
> +++ b/patches/29-sdio_no_suspend.patch
> @@ -84,3 +84,41 @@ suspend and resume that are not backported.
>    	}
>    };

It probably is obvious but could your patch elaborate on the 'why' for 
this deactivation for mere mortals like me ;-)

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


