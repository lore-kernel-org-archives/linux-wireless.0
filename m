Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52604 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab3HFJk5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 05:40:57 -0400
Message-ID: <5200C4A8.5070907@openwrt.org> (sfid-20130806_114100_685987_EE44AD98)
Date: Tue, 06 Aug 2013 11:40:56 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 01/12] ath9k: add utility functions for accessing tid
 queues
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org> <20992.41970.702140.69564@gargle.gargle.HOWL>
In-Reply-To: <20992.41970.702140.69564@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-08-06 9:21 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> -			if (skb_queue_empty(&tid->buf_q))
>> +			if (ath_tid_has_buffered(tid))
> 
> Shouldn't this be !ath_tid_has_buffered(tid) ?
Right, thanks.

- Felix

