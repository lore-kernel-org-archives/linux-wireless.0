Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:5204 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYL2QlI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 11:41:08 -0500
Subject: Re: [PATCH v3] ath9k: Enable dynamic power save in ath9k.
From: Pavel Roskin <proski@gnu.org>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081229145920.GC2914@myhost.users.atheros.com>
References: <20081229145920.GC2914@myhost.users.atheros.com>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 11:40:56 -0500
Message-Id: <1230568856.20811.6.camel@dv> (sfid-20081229_174113_502133_C8ADC01B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-29 at 20:29 +0530, Vivek Natarajan wrote:
>  	u16 ah_currentRD5G;
>  	u16 ah_currentRD2G;
>  	char ah_iso[4];
> +	enum ath9k_power_mode ah_powerMode;
> +	enum ath9k_power_mode ah_restoreMode;

I think camelCase is discouraged in Linux sources.  Sure, there are
exceptions, but they are normally caused by names used in standards or
other documentation.  I cannot find "powerMode" in any drivers other
than ath9k.

> -	enum ath9k_power_mode ah_powerMode;

That's good.  Let's follow Linux conventions for the new variable names.

-- 
Regards,
Pavel Roskin
