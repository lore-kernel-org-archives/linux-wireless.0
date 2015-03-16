Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:57916 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbbCPHpl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 03:45:41 -0400
Message-ID: <55068A22.5030208@openwrt.org> (sfid-20150316_084546_061224_9638801E)
Date: Mon, 16 Mar 2015 08:45:38 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: add an intermediate software queue implementation
References: <1426447133-28317-1-git-send-email-nbd@openwrt.org> <CANUX_P09MoMHS9sko+gxA7Ra-q+ppo1PXSSRXCsHpG19sTcFMA@mail.gmail.com>
In-Reply-To: <CANUX_P09MoMHS9sko+gxA7Ra-q+ppo1PXSSRXCsHpG19sTcFMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-03-16 08:25, Emmanuel Grumbach wrote:
> Hi Felix,
> 
> Sorry, but I saw one small typo :)
> 
> [snip]
> 
>> +
>> +/**
>> + * ieee80211_tx_dequeue - dequeue a packet from a software tx queue
>> + *
>> + * @hw: pointer as obtained from ieee80211_alloc_hw()
>> + * @txq: pointer obtained from .add_tx_queue() call
>> + *
>> + * Returns the sjb if successful, ERR_PTR(-EAGAIN) if no frame was available.
> 
> skb
Thanks, will send v3 after waiting a bit more for further comments.

- Felix
