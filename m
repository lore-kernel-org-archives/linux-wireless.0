Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41308
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbXKTFYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 00:24:01 -0500
Date: Mon, 19 Nov 2007 21:24:00 -0800 (PST)
Message-Id: <20071119.212400.210270305.davem@davemloft.net> (sfid-20071120_052405_829126_25E9FF86)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-davem' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071107030853.GB30169@tuxdriver.com>
References: <20071107030853.GB30169@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 6 Nov 2007 22:08:53 -0500

> Individual patches are available here:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/upstream-davem
 ...
> 
> Mattias Nissler (1):
>       mac80211: Accept auto txpower setting
> 
> Michael Wu (1):
>       ieee80211: Add IEEE80211_MAX_FRAME_LEN to linux/ieee80211.h

I've applied these two changes as patches to net-2.6.25, thanks John.
