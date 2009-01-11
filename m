Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56786
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751131AbZAKH5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 02:57:39 -0500
Date: Sat, 10 Jan 2009 23:57:40 -0800 (PST)
Message-Id: <20090110.235740.20607970.davem@davemloft.net> (sfid-20090111_085743_335355_650BBDBE)
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: Re: decisions, decisions...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090110.235141.223618374.davem@davemloft.net>
References: <20090110.235141.223618374.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Miller <davem@davemloft.net>
Date: Sat, 10 Jan 2009 23:51:41 -0800 (PST)

> So I'm going to rework the net-2.6 tree do that only bug fixes and
> -RCx material remains in there.  In particular the latest batch
> of net_dev_ops conversions are getting pulled out.
> 
> I'm going to put those removed changes aside somewhere locally, and I
> will not push them into net-next-2.6 until Stephen Rothwell gives the
> OK for that kind of stuff showing up in -next.

BTW, in case it wasn't obvious, this means net-2.6 will need to be
rebased.

I'll make a posting here when that has been completed.

Thanks.
