Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:52765 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbcBVTxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 14:53:49 -0500
Date: Mon, 22 Feb 2016 14:53:44 -0500 (EST)
Message-Id: <20160222.145344.1364935477504825011.davem@davemloft.net> (sfid-20160222_205358_665825_1FF06386)
To: emmanuel.grumbach@intel.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] codel: cast the output of MS2TIME to codel_time_t
From: David Miller <davem@davemloft.net>
In-Reply-To: <1456141787-18143-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456141787-18143-1-git-send-email-emmanuel.grumbach@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Mon, 22 Feb 2016 13:49:47 +0200

> This will allow to pass the typecheck in the comparators:
> codel_time_{after,before}
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

I do not see any existing code where this would matter.  Maybe it was
not meant to be fed directly?  And if you need to you should add the
explicit casts yourself.

I'm not applying this, sorry.

