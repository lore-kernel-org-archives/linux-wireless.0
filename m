Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56896
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761537AbZLKWUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 17:20:10 -0500
Date: Fri, 11 Dec 2009 14:20:16 -0800 (PST)
Message-Id: <20091211.142016.35345283.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-12-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091211193757.GC6663@tuxdriver.com>
References: <20091211193757.GC6663@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 11 Dec 2009 14:37:57 -0500

> Dave,
> 
> Here is another little batch of fixes intended for 2.6.33.  Most of them
> are tiny.  The rtl8187 led patch is self-contained and squashes a
> warning during suspend.  The regulatory rules update only applies to the
> people _not_ using CRDA, which should be fairly rare nowadays.  But
> still, anyone using that configuration should be working with current
> and safe rules.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
