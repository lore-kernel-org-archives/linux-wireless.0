Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:56672 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaJFBiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2014 21:38:55 -0400
Date: Sun, 05 Oct 2014 21:38:53 -0400 (EDT)
Message-Id: <20141005.213853.488066614144870837.davem@davemloft.net> (sfid-20141006_033918_137221_BC0D0F27)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-10-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141005.213511.339356320070784471.davem@davemloft.net>
References: <20141003180151.GE27414@tuxdriver.com>
	<20141005.213511.339356320070784471.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Miller <davem@davemloft.net>
Date: Sun, 05 Oct 2014 21:35:11 -0400 (EDT)

> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Fri, 3 Oct 2014 14:01:52 -0400
> 
>> Please pull tihs batch of updates intended for the 3.18 stream!
> 
> Pulled, thanks for the stellar pull request text, as always.

John, what's the deal with the following?  Will it be resolved by the
driver being removed from the staging tree?

WARNING: drivers/staging/rtl8192ee/r8192ee: 'rtl_evm_dbm_jaguar' exported twice. Previous export was in drivers/net/wireless/rtlwifi/rtlwifi.ko
