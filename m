Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38672
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbXHSXdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 19:33:00 -0400
Date: Sun, 19 Aug 2007 16:32:59 -0700 (PDT)
Message-Id: <20070819.163259.51518486.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Please pull 'upstream-davem' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070815003410.GJ7198@tuxdriver.com>
References: <20070815003234.GI7198@tuxdriver.com>
	<20070815003410.GJ7198@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 14 Aug 2007 20:34:10 -0400

> Johannes Berg (1):
>       radiotap parser: accept all other fields
> 
> Larry Finger (1):
>       mac80211: Add SIOCGIWTXPOWER routine

I've rebased net-2.6.24 and added in these two wireless
patches, thanks!
