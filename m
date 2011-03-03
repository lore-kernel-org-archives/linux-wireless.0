Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web161619.mail.bf1.yahoo.com ([98.139.211.141]:24786 "HELO
	web161619.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752257Ab1CCQJo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 11:09:44 -0500
Message-ID: <598769.17528.qm@web161619.mail.bf1.yahoo.com>
Date: Thu, 3 Mar 2011 08:09:42 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH] compat-wireless: rt2800pci (and rt2x00pci) don't unload on 'make unload'
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Greg Whiteley <greg.whiteley@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Greg Whiteley <greg.whiteley@gmail.com>
In-Reply-To: <1298970756-32328-1-git-send-email-greg.whiteley@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Add missing module names to
> scripts/unload.sh
> 
> Signed-off-by: Greg Whiteley
> ---
>  scripts/unload.sh |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/unload.sh b/scripts/unload.sh
> index 2af748a..abc5e72 100755
> --- a/scripts/unload.sh
> +++ b/scripts/unload.sh
> @@ -21,8 +21,8 @@ MODULES="$MODULES ath5k ath ath6kl
> ar9170usb carl9170"
>  MODULES="$MODULES p54pci p54usb p54spi p54common"
>  MODULES="$MODULES rt2400pci rt2500pci rt61pci"
>  MODULES="$MODULES rt2500usb rt73usb"
> -MODULES="$MODULES rt2800usb rt2800lib"
> -MODULES="$MODULES rt2x00usb rt2x00lib"
> +MODULES="$MODULES rt2800usb rt2800pci rt2800lib"
> +MODULES="$MODULES rt2x00usb rt2x00pci rt2x00lib"
>  MODULES="$MODULES rtl8180 rtl8187 rtl8192ce rtlwifi"
>  MODULES="$MODULES mwl8k mac80211_hwsim"
>  MODULES="$MODULES at76c50x_usb at76_usb"
> -- 
> 1.7.0.4

Add these to scripts/wlunload.sh as well.

Wlater


      
