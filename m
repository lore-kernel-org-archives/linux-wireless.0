Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:58154 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab3HFI5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 04:57:11 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20992.41970.702140.69564@gargle.gargle.HOWL> (sfid-20130806_105716_881226_6420A240)
Date: Tue, 6 Aug 2013 12:51:22 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 01/12] ath9k: add utility functions for accessing tid queues
In-Reply-To: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> -			if (skb_queue_empty(&tid->buf_q))
> +			if (ath_tid_has_buffered(tid))

Shouldn't this be !ath_tid_has_buffered(tid) ?

Sujith
