Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:56018 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3BYUqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 15:46:54 -0500
Date: Mon, 25 Feb 2013 15:46:52 -0500 (EST)
Message-Id: <20130225.154652.1215363481985361759.davem@davemloft.net> (sfid-20130225_214717_001524_FEA01385)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-02-25
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130225201748.GC6455@tuxdriver.com>
References: <20130225201748.GC6455@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 25 Feb 2013 15:17:49 -0500

> This is a batch of fixes intended for the 3.9 stream...
> 
> Avinash Patil gives us a mwifiex fix to prevent a system freeze when
> that driver is unloaded.
> 
> Daniel Drake brings a patch to avoid dropping the carrier flag across a
> suspend.  This prevents improper packet drops.
> 
> Wei Yongjun delivers a brcmfmac for a lock leak on an error path.
> 
> Please let me know if there are problems!

Pulled, thanks John.
