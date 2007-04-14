Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34728
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbXDNSQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2007 14:16:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 1/4] Mac80211: Add new names for statistics variables
Date: Sat, 14 Apr 2007 20:15:18 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <462119b6.sR44k/X6U4ToSXkJ%Larry.Finger@lwfinger.net>
In-Reply-To: <462119b6.sR44k/X6U4ToSXkJ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704142015.18660.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 14 April 2007 20:13, Larry Finger wrote:
> Index: wireless-dev/net/mac80211/ieee80211.c
> ===================================================================
> --- wireless-dev.orig/net/mac80211/ieee80211.c
> +++ wireless-dev/net/mac80211/ieee80211.c
> @@ -4211,7 +4211,7 @@ void ieee80211_rx_irqsafe(struct ieee802
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
>  
> -	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
> +//	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));

Whoops?

-- 
Greetings Michael.
