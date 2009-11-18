Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38820 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZKRPe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 10:34:56 -0500
Subject: Re: [PATCH 2/2] Adding  kerneldoc entry for radio type GPS
From: Marcel Holtmann <marcel@holtmann.org>
To: janakiram.sistla@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1258557771-10776-1-git-send-email-janakiram.sistla@gmail.com>
References: <1258557771-10776-1-git-send-email-janakiram.sistla@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 16:35:00 +0100
Message-ID: <1258558500.2003.88.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

> From: Janakiram Sistla <janakiram.sistla@gmail.com>
> 
> 
> Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
> ---
>  include/linux/rfkill.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index d787d5f..212f555 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -36,6 +36,7 @@
>   * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
>   * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
>   * @RFKILL_TYPE_FM: switch is on a FM device.
> + * @RFKILL_TYPE_GPS: switch is on a GPS device.
>   * @NUM_RFKILL_TYPES: number of defined rfkill types
>   */
>  enum rfkill_type {

so this is getting stupid right now. I am sick of a really simple patch
causes so much trouble. Even this one is wrong again. The GPS doc should
obviously before FM.

Regards

Marcel


