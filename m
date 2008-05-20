Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50503 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758779AbYETJ3w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 05:29:52 -0400
Subject: Re: iwlwifi injection bug
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
In-Reply-To: <1211274820.6252.75.camel@johannes.berg>
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
	 <1211274820.6252.75.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 20 May 2008 17:29:17 +0800
Message-Id: <1211275757.7814.20.camel@debian.sh.intel.com> (sfid-20080520_113316_003548_687A6FD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-20 at 11:13 +0200, Johannes Berg wrote:
> 
> Until then, however, you should return 0 and free the skb there to
> avoid messing up the whole networking layer's queuing.

I see the real problem now. Will do. Thanks!

-yi

