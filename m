Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49312
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754156AbZJMSmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 14:42:10 -0400
Date: Tue, 13 Oct 2009 11:42:06 -0700 (PDT)
Message-Id: <20091013.114206.00578027.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-10-13
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091013150558.GC2747@tuxdriver.com>
References: <20091013150558.GC2747@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 13 Oct 2009 11:05:58 -0400

> Here are a few (almost-)one-liners for 2.6.32.  Included are fixes for
> a use-after-free, a missing "!" in front of a memcmp when comparing
> BSSIDs, a race when using hardware-based scanning, the ieee80211_rx
> context problem, a related documentation change, and a minor build
> issue.
> 
> Please let me know if there are problems!

Pulled, thanks a lot!
