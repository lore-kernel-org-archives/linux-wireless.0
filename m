Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47626 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZDVNa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 09:30:56 -0400
Date: Wed, 22 Apr 2009 09:27:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
Message-ID: <20090422132723.GC3288@tuxdriver.com> (sfid-20090422_153100_730025_48613A12)
References: <1240248385.5260.15.camel@localhost.localdomain> <1240248773.4632.13.camel@johannes.local> <1240343775.3327.3.camel@localhost.localdomain> <1240348792.17388.46.camel@johannes.local> <1240385542.3404.5.camel@localhost.localdomain> <1240391029.20308.1.camel@johannes.local> <1240391541.10072.2.camel@localhost.localdomain> <1240393523.21978.1.camel@johannes.local> <1240399028.10072.14.camel@localhost.localdomain> <1240401205.3313.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1240401205.3313.3.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 22, 2009 at 12:53:25PM +0100, Marcel Holtmann wrote:

> <starting dhclient wlan0 now>
> 
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> l2_packet_receive - recvfrom: Network is down
> CTRL-EVENT-SCAN-RESULTS 
> Trying to authenticate with 00:1f:f3:fa:58:59 (SSID='HON Circle' freq=2452 MHz)
> Trying to associate with 00:1f:f3:fa:58:59 (SSID='HON Circle' freq=2452 MHz)
> Associated with 00:1f:f3:fa:58:59
> WPA: Key negotiation completed with 00:1f:f3:fa:58:59 [PTK=CCMP GTK=CCMP]
> CTRL-EVENT-CONNECTED - Connection to 00:1f:f3:fa:58:59 completed (reauth) [id=1 id_str=]
> 
> For some reason the dhclient triggers the disconnect and I see the
> network down. With this kernel it reconnects properly and then dhclient
> succeeds. This is against an N-capable AirPort Express.

IIRC, dhclient is prone to 'bouncing' the interface (i.e. down/up).
I have seen it do that, but I can't remember what the circumstances
were.  Anyway, maybe it was worth mentioning...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
