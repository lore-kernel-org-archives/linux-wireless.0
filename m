Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44337
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761207AbXHOXJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 19:09:05 -0400
Date: Wed, 15 Aug 2007 16:09:04 -0700 (PDT)
Message-Id: <20070815.160904.78710870.davem@davemloft.net>
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

> Individual patches available here:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/upstream-davem

John, what I'm going to do is wait for Linus to pull in the
2.6.23 mac80211 fixes you submitted yesterday, then rebase
the net-2.6.24 tree and add these fixes on top.

Take care.
