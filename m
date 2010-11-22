Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61405 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab0KVVXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 16:23:37 -0500
Received: by qyk11 with SMTP id 11so709351qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 13:23:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290165802-3566-1-git-send-email-rmanoharan@atheros.com>
References: <1290165802-3566-1-git-send-email-rmanoharan@atheros.com>
Date: Mon, 22 Nov 2010 16:23:36 -0500
Message-ID: <AANLkTimTGAr5aA-CkuvezH4FXTs2SD4MnYTmWo7Ru44p@mail.gmail.com>
Subject: Re: [PATCH 1/4] ath: Add a driver_info bitmask field
From: Bob Copeland <me@bobcopeland.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 19, 2010 at 6:23 AM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> The driver_info stores the device category information which
> is used to load appropriate device firmware, select firmware offset
> and eeprom starting location. The driver_info is accessed across
> ath9k_htc and ath9k_hw. Hence placed under common structure.

>  /**
>  * struct ath_ops - Register read/write operations
>  *
> @@ -147,6 +152,7 @@ struct ath_common {
>        u8 rx_chainmask;
>
>        u32 rx_bufsize;
> +       u32 driver_info;


u32 for 2 bits?

-- 
Bob Copeland %% www.bobcopeland.com
