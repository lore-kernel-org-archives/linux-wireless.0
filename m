Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50557 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbXH1RIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 13:08:34 -0400
Date: Tue, 28 Aug 2007 18:08:32 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] Net: ath5k, split hw into hw, phy and initvals
Message-ID: <20070828170832.GA29343@infradead.org>
References: <2713029743177393055@pripojeni.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2713029743177393055@pripojeni.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 28, 2007 at 11:58:52AM -0400, Jiri Slaby wrote:
>  obj-$(CONFIG_ATH5K)	+= ath5k.o
> -ath5k-objs		= ath5k_base.o ath5k_hw.o ath5k_regdom.o
> +ath5k-objs		= ath5k_base.o ath5k_hw.o ath5k_regdom.o \
> +			  ath5k_hw_phy.o ath5k_hw_inivals.o

Btw, this should be ath5k-y += ath5k_base.o ath5k_hw.o ath5k_regdom.o \

