Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42159 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbcFPQHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 12:07:16 -0400
From: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
To: Arthur Jagiella <jagiella@vitracom.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: RE: [PATCH] ath10k: Fix a typo in spectral code commments
Date: Thu, 16 Jun 2016 16:06:52 +0000
Message-ID: <eb4c30ff7ff54ea2b63a950acecdd51a@aphydexm01b.ap.qualcomm.com> (sfid-20160616_180729_980828_BB2C374D)
References: <1465882434-594-1-git-send-email-mohammed@qca.qualcomm.com>
 <575FC1E5.90108@vitracom.de>
In-Reply-To: <575FC1E5.90108@vitracom.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux wireless, ath10k

Thanks, initially I could not get what you meant :(

-----Original Message-----
From: Arthur Jagiella [mailto:jagiella@vitracom.de] 
Sent: Tuesday, June 14, 2016 2:06 PM
To: Shajakhan, Mohammed Shafi (Mohammed Shafi) <mohammed@qti.qualcomm.com>
Subject: Re: [PATCH] ath10k: Fix a typo in spectral code commments

smaples?



Am 14.06.2016 um 07:33 schrieb Mohammed Shafi Shajakhan:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> Found this obvious typo while going through the spectral code design 
> in ath10k
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath10k/spectral.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/spectral.c 
> b/drivers/net/wireless/ath/ath10k/spectral.c
> index 4671cfb..4510906 100644
> --- a/drivers/net/wireless/ath/ath10k/spectral.c
> +++ b/drivers/net/wireless/ath/ath10k/spectral.c
> @@ -101,7 +101,7 @@ int ath10k_spectral_process_fft(struct ath10k *ar,
>   		break;
>   	case 80:
>   		/* TODO: As experiments with an analogue sender and various
> -		 * configuaritions (fft-sizes of 64/128/256 and 20/40/80 Mhz)
> +		 * configurations (fft-sizes of 64/128/256 and 20/40/80 Mhz)
>   		 * show, the particular configuration of 80 MHz/64 bins does
>   		 * not match with the other smaples at all. Until the reason
>   		 * for that is found, don't report these samples.

--
Arthur Jagiella
Praktikant
Forschung und Entwicklung
Vitracom AG

Erbprinzenstr. 4-12, A
D-76133 Karlsruhe

Email: jagiella@vitracom.de
Internet: www.vitracom.de



------------------------------------------------
HRB Mannheim 111263
UST-ID: DE 247872702
Vorstand: Axel Stephan,
           Ralph Majer
Aufsichtsrat: Paul A. Stodden (Vors.)
               Christian Eckart, Sacha Grau
------------------------------------------------

