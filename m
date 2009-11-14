Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42388 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZKNQef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 11:34:35 -0500
Subject: Re: [patch 0/1] Adding radio type FM
From: Marcel Holtmann <marcel@holtmann.org>
To: Janakiram Sistla <janakiram.sistla@gmail.com>
Cc: majordomo@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
In-Reply-To: <4fb5db50911140519q70bbdd00qb585153c4926df96@mail.gmail.com>
References: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
	 <1258082571.7715.13.camel@violet>
	 <4fb5db50911140519q70bbdd00qb585153c4926df96@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Nov 2009 17:34:34 +0100
Message-ID: <1258216474.3299.24.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Janakiram,

> Resubmitting patch  adding Marcels Comments
> 
> From f72e4bdef7c423259f2f8f0615d024a25294ea8f Mon Sep 17 00:00:00 2001
> From: Janakiram Sistla <janakiram.sistla@gmail.com>
> Date: Sat, 14 Nov 2009 18:42:35 +0530
> Subject: [PATCH 1/1] Adding radio type FM
> 
> Adding radio type FM in RFKILL_TYPE_.FM also belongs to
> same class of with both TX/RX capability.
> 
> Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
> ---
>  include/linux/rfkill.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index 3392c59..03f5598 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -45,6 +45,7 @@ enum rfkill_type {
>  	RFKILL_TYPE_WIMAX,
>  	RFKILL_TYPE_WWAN,
>  	RFKILL_TYPE_GPS,
> +	RFKILL_TYPE_FM,
>  	NUM_RFKILL_TYPES,
>  };

and what about rfkill_get_type_str() changes?

Regards

Marcel


