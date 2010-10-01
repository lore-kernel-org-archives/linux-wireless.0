Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55789 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0JADRU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 23:17:20 -0400
Received: by qyk9 with SMTP id 9so264421qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 20:17:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285874578-5191-1-git-send-email-greearb@candelatech.com>
References: <1285874578-5191-1-git-send-email-greearb@candelatech.com>
Date: Thu, 30 Sep 2010 23:17:19 -0400
Message-ID: <AANLkTi=esnnEOThKQPKYSBcHXaHp-ssfDmOqdzcKbcaA@mail.gmail.com>
Subject: Re: [PATCH v9] ath5k: Allow ath5k to support virtual STA and AP interfaces.
From: Bob Copeland <me@bobcopeland.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>        struct ath5k_softc *sc = hw->priv;
> +       struct ath5k_vif *avf = (void *)vif->drv_priv;
>        struct sk_buff *skb;

Nothing to do with your patch, but can we get a vif_to_priv()
wrapper or something?  Seeing casts to void * makes me queasy...

-- 
Bob Copeland %% www.bobcopeland.com
