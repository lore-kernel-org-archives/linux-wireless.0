Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38467 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267Ab2EPRza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 13:55:30 -0400
Message-ID: <1337190928.18519.11.camel@jlt3.sipsolutions.net> (sfid-20120516_195537_606939_30EE470C)
Subject: Re: [PATCH] iwlwifi: add __printf argument checking
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 16 May 2012 19:55:28 +0200
In-Reply-To: <20120516174121.GF3508@tuxdriver.com>
References: <1337086877.4546.4.camel@jlt3.sipsolutions.net>
	 <20120516174121.GF3508@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-16 at 13:41 -0400, John W. Linville wrote:
> This one causes a few warnings here -- can we fix those at the same time as we add this?
> 
>   CC      drivers/net/wireless/iwlwifi/iwl-agn-sta.o
> drivers/net/wireless/iwlwifi/iwl-agn-sta.c: In function ‘iwl_sta_calc_ht_flags’:
> drivers/net/wireless/iwlwifi/iwl-agn-sta.c:238:2: warning: too few arguments for format
> 
>   CC      drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.o
> drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: In function ‘iwl_rx_handle’:
> drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:516:3: warning: format ‘%d’ expects type ‘int’, but argument 6 has type ‘struct iwl_rx_mem_buffer *’
> drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:516:3: warning: too few arguments for format

I think they were gone by the time I did this, but you said you had to
skip a few patches (some of which fixed such bugs) as they didn't apply.

johannes

