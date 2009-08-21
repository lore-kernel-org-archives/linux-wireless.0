Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39327
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932359AbZHUUNG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:13:06 -0400
Date: Fri, 21 Aug 2009 13:13:18 -0700 (PDT)
Message-Id: <20090821.131318.130589385.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-08-21
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090821170324.GC8532@tuxdriver.com>
References: <20090821170324.GC8532@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 21 Aug 2009 13:03:25 -0400

> One more straggler for 2.6.31...without this rtl8187b devices simply
> don't work. :-(
> 
> The patch is small and isolated to rtl8187.  I think we should take
> it for 2.6.31.
> 
> Please let me know if there are problems!

Pulled, and I'll push out to kernel.org after a test build.

Thanks!
