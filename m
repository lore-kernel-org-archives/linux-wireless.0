Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:40867 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYJ2Om6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 10:42:58 -0400
Received: by wf-out-1314.google.com with SMTP id 27so23962wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 07:42:57 -0700 (PDT)
Message-ID: <40f31dec0810290742j2c94e047u8548dfe2bdcde058@mail.gmail.com> (sfid-20081029_154301_468712_C7C165B9)
Date: Wed, 29 Oct 2008 16:42:57 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: update keycache to support TKIP handling
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1225283457-24417-3-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225283457-24417-3-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
> index 69755fc..037e36d 100644
> --- a/drivers/net/wireless/ath5k/reg.h
> +++ b/drivers/net/wireless/ath5k/reg.h
> @@ -1811,6 +1811,7 @@
>  #define AR5K_KEYTABLE_ANTENNA          0x00000008      /* [5212+] */
>  #define AR5K_KEYTABLE_MAC0(_n)         AR5K_KEYTABLE_OFF(_n, 6)
>  #define AR5K_KEYTABLE_MAC1(_n)         AR5K_KEYTABLE_OFF(_n, 7)
> +#define AR5K_KEYTABLE_MIC_OFFSET       64
>  #define AR5K_KEYTABLE_VALID            0x00008000
>
>  /* If key type is TKIP and MIC is enabled

Just below...

/* If key type is TKIP and MIC is enabled
 * MIC key goes in offset entry + 64 */
#define	AR5K_KEYTABLE_MIC_OFFSET	64


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
