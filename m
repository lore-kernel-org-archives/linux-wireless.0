Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41247
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755219Ab1CVVfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 17:35:44 -0400
Date: Tue, 22 Mar 2011 14:36:22 -0700 (PDT)
Message-Id: <20110322.143622.189692906.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-03-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110322174616.GB2512@tuxdriver.com>
References: <20110322174616.GB2512@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 22 Mar 2011 13:46:17 -0400

> Here is a batch of fixes intended for 2.6.39.  Included are a lock
> leak fix for iwlwifi, a "hold the lock longer" fix for orinoco, an
> rtlwifi fix for a memset argument ordering problem, a sta structure
> initialization fix for mac80211, an ath9k NULL pointer fix, a
> kernel-doc fix, and a handful of device IDs.

Pulled, thanks a lot John.
