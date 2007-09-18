Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42495
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756123AbXIRTXK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 15:23:10 -0400
Date: Tue, 18 Sep 2007 12:22:58 -0700 (PDT)
Message-Id: <20070918.122258.82101397.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Please pull 'iwlwifi' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070918185040.GF4940@tuxdriver.com>
References: <20070918185040.GF4940@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 18 Sep 2007 14:50:40 -0400

> Jeff & Dave,
> 
> Here it is -- it's big, it's...well...beautiful in its own way...well,
> at least it seems to work... :-)
> 
> There are some outstanding issues.  The driver does more than it
> probably should under the covers instead of in the stack, and the
> issue of including headers with a "../../mac80211/..." path remains.
> Still, I think it would be better to get this mainlined than to keep
> it out of stream.

Jeff, if you have no objections I'll pull this into net-2.6.24

Thanks.
