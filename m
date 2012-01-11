Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4323 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab2AKVDk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 16:03:40 -0500
Message-ID: <4F0DF91F.6020005@broadcom.com> (sfid-20120111_220344_035748_31534F96)
Date: Wed, 11 Jan 2012 22:03:27 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: add default option to avoid duplicating device
 support with brcmsmac
References: <1326315180-29398-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1326315180-29398-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2012 09:53 PM, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/b43/Kconfig |    5 +++++
>  drivers/net/wireless/b43/main.c  |    2 ++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
> +config B43_BCMA_EXTRA
> +	bool "Support for devices also supported by brcmsmac"
> +	depends on B43_BCMA
> +	default n

If I am not mistaken the 'default n' is not really needed.

Gr. AvS

