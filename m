Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:33120 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbbCPHZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 03:25:46 -0400
Received: by ladw1 with SMTP id w1so32175910lad.0
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2015 00:25:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426447133-28317-1-git-send-email-nbd@openwrt.org>
References: <1426447133-28317-1-git-send-email-nbd@openwrt.org>
Date: Mon, 16 Mar 2015 09:25:44 +0200
Message-ID: <CANUX_P09MoMHS9sko+gxA7Ra-q+ppo1PXSSRXCsHpG19sTcFMA@mail.gmail.com> (sfid-20150316_082549_189754_C3B10FEC)
Subject: Re: [PATCH v2] mac80211: add an intermediate software queue implementation
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

Sorry, but I saw one small typo :)

[snip]

> +
> +/**
> + * ieee80211_tx_dequeue - dequeue a packet from a software tx queue
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + * @txq: pointer obtained from .add_tx_queue() call
> + *
> + * Returns the sjb if successful, ERR_PTR(-EAGAIN) if no frame was available.

skb

> + */
> +struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
> +                                    struct ieee80211_txq *txq);
> +
> +
>  #endif /* MAC80211_H */
