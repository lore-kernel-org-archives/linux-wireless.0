Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:58834 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3HFI5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 04:57:13 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20992.43399.220167.743676@gargle.gargle.HOWL> (sfid-20130806_105718_665178_984BA793)
Date: Tue, 6 Aug 2013 13:15:11 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 07/12] ath9k: prepare queueing code for handling unaggregated traffic
In-Reply-To: <1375732583-39001-7-git-send-email-nbd@openwrt.org>
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
	<1375732583-39001-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> +		tx_info = IEEE80211_SKB_CB(skb);
> +		tx_info->flags &= ~IEEE80211_TX_CTL_CLEAR_PS_FILT;

Why is the PS filter flag cleared here ?

> -	txtid->paused = true;
> +	txtid->paused = false;

Why change this ?

Sujith
