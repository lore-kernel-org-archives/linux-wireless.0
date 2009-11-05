Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:41892 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZKEC7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 21:59:35 -0500
Received: by fg-out-1718.google.com with SMTP id d23so2178578fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 18:59:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257389729-26491-1-git-send-email-keng-yu.lin@canonical.com>
References: <1257389729-26491-1-git-send-email-keng-yu.lin@canonical.com>
Date: Wed, 4 Nov 2009 21:59:39 -0500
Message-ID: <b6c5339f0911041859v762f90f4u1b369a80841ea756@mail.gmail.com>
Subject: Re: [PATCH] ath5k: add LED support for Acer Aspire One AO751h/AO531h
From: Bob Copeland <me@bobcopeland.com>
To: Keng-Yu Lin <keng-yu.lin@canonical.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 9:55 PM, Keng-Yu Lin <keng-yu.lin@canonical.com> wrote:
> Add LED support for a Foxconn AR242X module, found on
> the Acer Aspire One models AO751h/AO531h
>
> Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
> ---
>  drivers/net/wireless/ath/ath5k/led.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
> index b767c3b..21a42a1 100644
> --- a/drivers/net/wireless/ath/ath5k/led.c
> +++ b/drivers/net/wireless/ath/ath5k/led.c
> @@ -59,6 +59,8 @@ static const struct pci_device_id ath5k_led_devices[] = {
>        { ATH_SDEVICE(PCI_VENDOR_ID_COMPAQ, PCI_ANY_ID), ATH_LED(1, 1) },
>        /* Acer Aspire One A150 (maximlevitsky@gmail.com) */
>        { ATH_SDEVICE(PCI_VENDOR_ID_FOXCONN, 0xe008), ATH_LED(3, 0) },
> +       /* Acer Aspire One AO531h AO751h */
> +       { ATH_SDEVICE(PCI_VENDOR_ID_FOXCONN, 0xe00d), ATH_LED(3, 0) },

Acked-by: Bob Copeland <me@bobcopeland.com>

... but can you by chance put a contact address in the comment?  I've been
collecting them in case we one day figure out a better way to do this so it's
easy to find the people to retest.

-- 
Bob Copeland %% www.bobcopeland.com
