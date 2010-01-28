Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58693
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718Ab0A1Nno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 08:43:44 -0500
Date: Thu, 28 Jan 2010 05:43:55 -0800 (PST)
Message-Id: <20100128.054355.206229204.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-01-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100127213511.GK2962@tuxdriver.com>
References: <20100127213511.GK2962@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 27 Jan 2010 16:35:12 -0500

> Dave,
> 
> Here is another small collections of fixes intended for 2.6.33.
> Included are a NULL pointer dereference fix, a buffer leak fix,
> a warning fix, and a correction of an ath9k initialization change
> that was improperly limited to only dual-band hardware.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
