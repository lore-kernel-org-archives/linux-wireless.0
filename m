Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:54493 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1LUTkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 14:40:04 -0500
Date: Wed, 21 Dec 2011 14:38:57 -0500 (EST)
Message-Id: <20111221.143857.1290958187108678143.davem@davemloft.net> (sfid-20111221_204008_355128_C2571EE7)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-12-21
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111221185914.GD11842@tuxdriver.com>
References: <20111221185914.GD11842@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 21 Dec 2011 13:59:14 -0500

> A few last(?) fixes intended for 3.2...
> 
> The biggest portion are from Gustavo:
> 
> "3 fixes for 3.2! There one revert that was causing connection issues,
> a RFCOMM fix to a potential kernel panic, and the last on L2CAP to
> a possible access to uninitialized data due to broken remote devices."
> 
> Also, an iwlwifi fix for a problem causing firmware asserts.
> 
> Please let me know if there are problems!

Pulled, thanks John.
