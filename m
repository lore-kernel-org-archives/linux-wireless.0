Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45352 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab1KPDR0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 22:17:26 -0500
Subject: Re: Build Error Report
From: wwguy <wey-yi.w.guy@intel.com>
To: Masahiro Inoue <miyabi.-.inoue@nifty.com>, Berg@vger.kernel.org,
	Johannes <johannes.berg@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111116104133.E58B.2E210E2F@nifty.com>
References: <20111116104133.E58B.2E210E2F@nifty.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Nov 2011 19:11:10 -0800
Message-ID: <1321413070.1796.43.camel@wwguy-ubuntu> (sfid-20111116_041731_230210_0AAA8175)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hmm, Johannes, I guess we miss this one

wey

On Tue, 201-15 at 17:41 -0800, Masahiro Inoue wrote:
> Hello,
> 
> The build error occurs by compat-wireless-2011-11-10.
> hmmMy kernel is 2.6.27.

> 
>   CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-calib.o
> /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-calib.c: In function 'iwlagn_gain_computation':
> /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-calib.c:891: warning: comparison of distinct pointer types lacks a cast
>   CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-io.o
>   CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-tt.o
>   CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-sta.o
>   CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.o
> /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c: In function 'iwlagn_rx_noa_notification':
> /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: implicit declaration of function 'kfree_rcu'
> /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: 'rcu_head' undeclared (first use in this function)
> /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: (Each undeclared identifier is reported only once
> /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: for each function it appears in.)
> make[4]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.o] Error 1
> make[3]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi] Error 2
> make[2]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless] Error 2
> make[1]: *** [_module_/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15] Error 2
> make[1]: Leaving directory `/usr/src/kernels/2.6.27-74vl5-x86_64'
> make: *** [modules] Error 2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


