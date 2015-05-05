Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:57235 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752363AbbEEGpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 02:45:01 -0400
Message-ID: <1430808298.7191.1.camel@perches.com> (sfid-20150505_084529_758029_564CAF7E)
Subject: Re: [PATCH v3] adm8211: fix checkpatch error for trailing
 statements on next line
From: Joe Perches <joe@perches.com>
To: Okash Khawaja <okash.khawaja@gmail.com>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 04 May 2015 23:44:58 -0700
In-Reply-To: <20150505060150.GA2548@bytefire-computer>
References: <20150505060150.GA2548@bytefire-computer>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-05 at 07:01 +0100, Okash Khawaja wrote:
> This patch fixes the checkpatch.pl error:

Please fix the space/tab use too.

Your email client seems to have converted all the tabs
to spaces.

default should use the same indent as the case statements


> diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
[]
> @@ -1098,14 +1098,18 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
>                 pci_read_config_byte(priv->pdev, PCI_CACHE_LINE_SIZE, &cline);
>  
>                 switch (cline) {
> -               case  0x8: reg |= (0x1 << 14);
> -                          break;
> -               case 0x16: reg |= (0x2 << 14);
> -                          break;
> -               case 0x32: reg |= (0x3 << 14);
> -                          break;
> -                 default: reg |= (0x0 << 14);
> -                          break;
> +               case  0x8:
> +                       reg |= (0x1 << 14);
> +                       break;
> +               case 0x16:
> +                       reg |= (0x2 << 14);
> +                       break;
> +               case 0x32:
> +                       reg |= (0x3 << 14);
> +                       break;
> +                 default:
> +                       reg |= (0x0 << 14);
> +                       break;
>                 }
>         }
>  

