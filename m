Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37868
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817Ab0AZMP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 07:15:58 -0500
Date: Tue, 26 Jan 2010 04:16:10 -0800 (PST)
Message-Id: <20100126.041610.226004766.davem@davemloft.net>
To: kalle.valo@iki.fi
Cc: kaber@trash.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Network QoS support in applications
From: David Miller <davem@davemloft.net>
In-Reply-To: <877hr5nkx0.fsf@purkki.valot.fi>
References: <87k4v5nuej.fsf@purkki.valot.fi>
	<4B5ED254.7010104@trash.net>
	<877hr5nkx0.fsf@purkki.valot.fi>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 26 Jan 2010 13:51:55 +0200

> Let's take a bittorrent client as an example. The traffic it generates
> is not important and it doesn't matter if bittorrent packets have
> lower priority compared to other streams. What SO_PRIORITY value
> should all bittorrent clients to use to mark their packets as low
> priority (for example background class from IEEE 802.1d Annex G).

This is a local policy decision.

There is no universal way of doing any of this, really.
