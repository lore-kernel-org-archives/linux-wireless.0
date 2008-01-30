Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:5633 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbYA3Snz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 13:43:55 -0500
Received: by an-out-0708.google.com with SMTP id d31so82503and.103
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2008 10:43:54 -0800 (PST)
Message-ID: <40f31dec0801301043u6f1ba910j7d06f2e0b4f674db@mail.gmail.com> (sfid-20080130_184422_895655_AAB7B466)
Date: Wed, 30 Jan 2008 20:43:54 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com, johannes@sipsolutions.net
Subject: Re: [ath5k-devel] [PATCH] ath5k: Port to new bitrate/channel API
In-Reply-To: <20080130183824.GA7676@makis.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080130183824.GA7676@makis.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
> index c79066b..3c987d3 100644
> --- a/drivers/net/wireless/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath5k/ath5k.h
> @@ -30,7 +30,6 @@
>  #include <net/mac80211.h>
>
>  #include "hw.h"
> -#include "regdom.h"
>

Also after this patch regdom.h/c can be removed since we are moving to
the new regdomain  handling ;-)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
