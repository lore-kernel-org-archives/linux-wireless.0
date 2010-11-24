Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43829
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442Ab0KXRVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 12:21:55 -0500
Date: Wed, 24 Nov 2010 09:22:21 -0800 (PST)
Message-Id: <20101124.092221.112611592.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-11-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101123210518.GB2372@tuxdriver.com>
References: <20101123210518.GB2372@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 23 Nov 2010 16:05:19 -0500

> Dave,
> 
> Here are some fixes intended for 2.6.37 -- a collection of one-liners!  :-)
> 
> The carl9170 patch fixes a NULL pointer dereference.  The b43-pci-bridge
> one just adds a device ID.  The ath9k patch fixes a timeout that also
> triggers a warning in dmesg.  Finally, the b43 patch fixes a resource
> leak on an error path.
> 
> Please let me know if there are problems!

Pulled, thanks John.
