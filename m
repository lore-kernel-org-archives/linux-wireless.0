Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41262 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2GCXre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 19:47:34 -0400
Received: by werb14 with SMTP id b14so3873928wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 16:47:33 -0700 (PDT)
Message-ID: <4FF38492.20003@gmail.com> (sfid-20120704_014809_093298_35F63183)
Date: Wed, 04 Jul 2012 01:47:30 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linville@tuxdriver.com, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Update regulatory rules for ES (Spain)
 on 5GHz and 2.4GHz
References: <1341350730-11037-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1341350730-11037-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/03/2012 11:25 PM, Xose Vazquez Perez wrote:
> Spanish law was based on CEPT/EU rules:
> http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000058.html
> http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000059.html
>
>
> Orden ITC/332/2010, de 12 de febrero, por la que se aprueba el cuadro
> nacional de atribución de frecuencias (CNAF):
> https://www.boe.es/diario_boe/txt.php?id=BOE-A-2010-2719
> https://www.boe.es/boe/dias/2010/02/19/pdfs/BOE-A-2010-2719.pdf
>
> search for:
>   UN - 85 RLANs y datos en 2400 a 2483,5 MHz (pag. 213)
>   UN – 128 RLANs en 5 GHz (pag. 232)
>
> more info at "Cuadro nacional de atribución de frecuencias (CNAF)":
> http://www.minetur.gob.es/telecomunicaciones/espectro/paginas/cnaf.aspx
>
> ---
>   db.txt |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/db.txt b/db.txt
> index 4c54543..11409d6 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -239,10 +239,10 @@ country EG:
>   	(5250 - 5330 @ 20), (N/A, 20), DFS
>
>   country ES: DFS-ETSI
> -	(2402 - 2482 @ 40), (N/A, 20)
> -	(5170 - 5250 @ 40), (N/A, 20)
> -	(5250 - 5330 @ 40), (N/A, 20), DFS
> -	(5490 - 5710 @ 40), (N/A, 27), DFS
> +	(2400 - 2483.5 @ 40), (N/A, 100 mW)
> +	(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
> +	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
> +	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
>
>   country FI: DFS-ETSI
>   	(2402 - 2482 @ 40), (N/A, 20)
>

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
