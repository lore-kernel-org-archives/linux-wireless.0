Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:59906 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2BOTvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 14:51:52 -0500
Date: Wed, 15 Feb 2012 14:50:39 -0500 (EST)
Message-Id: <20120215.145039.1816967174435860741.davem@davemloft.net> (sfid-20120215_205210_544932_CB6B1077)
To: linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless 2012-02-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120215192106.GI4379@tuxdriver.com>
References: <20120215192106.GI4379@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 15 Feb 2012 14:21:06 -0500

> Here are two more fixes intended for 3.3.  One changes the non-error
> return code for a routine in rtlwifi -- it had been masking an error
> condition that could lead to a divide by zero.  The other moves a
> routine inside of a locked critical section to avoid a "BUG: rwlock bad
> magic".
> 
> Please let me know if there are problems!

Pulled.
