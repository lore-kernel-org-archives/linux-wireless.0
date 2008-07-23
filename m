Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50117
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753573AbYGWWUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 18:20:05 -0400
Date: Wed, 23 Jul 2008 15:20:05 -0700 (PDT)
Message-Id: <20080723.152005.243538730.davem@davemloft.net> (sfid-20080724_002010_482815_033A7D78)
To: tytso@MIT.EDU
Cc: yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Potential iwlwifi locking problem in 2.6.26-git9
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1KLm0c-0002O6-RO@closure.thunk.org>
References: <E1KLm0c-0002O6-RO@closure.thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Theodore Ts'o" <tytso@MIT.EDU>
Date: Wed, 23 Jul 2008 17:36:30 -0400

> 
> Is this a new one?  I don't think I've seen this on LKML....

Yes, we have, we're trying to work it out on netdev.
