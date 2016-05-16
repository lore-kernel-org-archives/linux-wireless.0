Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41504 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750787AbcEPLl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 07:41:56 -0400
Message-ID: <1463398895.25219.82.camel@coelho.fi> (sfid-20160516_134159_037647_4F79B8FD)
From: Luca Coelho <luca@coelho.fi>
To: Dan Carpenter <dan.carpenter@oracle.com>, sara.sharon@intel.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 16 May 2016 14:41:35 +0300
In-Reply-To: <20160513085428.GA13194@mwanda>
References: <20160513085428.GA13194@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi: mvm: add reorder buffer per queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-05-13 at 11:54 +0300, Dan Carpenter wrote:
> Hello Sara Sharon,
> 
> The patch b915c10174fb: "iwlwifi: mvm: add reorder buffer per queue"
> from Mar 23, 2016, leads to the following static checker warnings:
> 
> 	drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:912
> iwl_mvm_rx_mpdu_mq()
> 	error: potential NULL dereference 'sta'.
> 
> 	drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:912
> iwl_mvm_rx_mpdu_mq()
> 	error: we previously assumed 'sta' could be null (see line 796)

Thanks for the analysis and report, Dan!

I have queued a fix for this through our internal tree.

--
Cheers,
Luca.
