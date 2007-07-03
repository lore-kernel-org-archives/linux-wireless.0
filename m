Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57908
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbXGCFif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 01:38:35 -0400
Date: Mon, 02 Jul 2007 22:38:54 -0700 (PDT)
Message-Id: <20070702.223854.78161801.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add support for SIOCGIWRATE ioctl to provide  rate information
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070612012319.GH20422@tuxdriver.com>
References: <20070610.181704.73383002.davem@davemloft.net>
	<20070612012228.GG20422@tuxdriver.com>
	<20070612012319.GH20422@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 11 Jun 2007 21:23:19 -0400

> From: Larry Finger <Larry.Finger@lwfinger.net>
> 
> At present, transmission rate information for mac80211 is available only
> if verbose debugging is turned on, and then only in the logs. This patch
> implements the SIOCGIWRATE ioctl, which adds the current transmission rate to
> the output of iwconfig.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

This change appears to already be in the tree.
