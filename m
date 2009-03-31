Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53572
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763208AbZCaVLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 17:11:51 -0400
Date: Tue, 31 Mar 2009 14:11:39 -0700 (PDT)
Message-Id: <20090331.141139.188200200.davem@davemloft.net> (sfid-20090331_231220_106305_A0D90E92)
To: kyle@mcmartin.ca
Cc: gregkh@suse.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: at76_usb convert to netdev_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090331201850.GC25513@bombadil.infradead.org>
References: <20090331201850.GC25513@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kyle McMartin <kyle@mcmartin.ca>
Date: Tue, 31 Mar 2009 16:18:50 -0400

> Didn't see this in your patch queue, fixes build on Fedora, though we'll
> probably end up turning on CONFIG_COMPAT_NET_DEV_OPS for now anyway.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
