Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53022 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab3HFJxx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 05:53:53 -0400
Message-ID: <5200C7A7.2000303@openwrt.org> (sfid-20130806_115357_156692_9BBCC5C2)
Date: Tue, 06 Aug 2013 11:53:43 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 11/12] ath9k: improve tx scheduling fairness
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org> <1375732583-39001-11-git-send-email-nbd@openwrt.org> <20992.47215.657712.108336@gargle.gargle.HOWL>
In-Reply-To: <20992.47215.657712.108336@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-08-06 10:48 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> Instead of trying to schedule the same TID multiple times in a loop,
>> iterate over other TIDs/stations first.
> 
> The txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH check in the beginning 
> of txq_schedule() is not really correct after this, no ?
Right, I'll take care of that.

Thanks for the detailed review.

- Felix
