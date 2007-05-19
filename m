Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54010 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbXESFhs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2007 01:37:48 -0400
Message-ID: <464E8CFC.8070801@garzik.org>
Date: Sat, 19 May 2007 01:37:00 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Florin Malita <fmalita@gmail.com>, marcelo@kvack.org,
	linville@redhat.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: skb dereferenced after netif_rx
References: <464B7127.5080502@gmail.com>	<20070518180903.GC3492@tuxdriver.com> <20070518222308.11c2b34d@localhost>
In-Reply-To: <20070518222308.11c2b34d@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Hemminger wrote:
> netif_rx() used to return a value in older kernels.

netif_rx() returns a value in current kernels.

	Jeff


