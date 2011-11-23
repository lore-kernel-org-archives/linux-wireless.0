Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:38609 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab1KWUtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 15:49:07 -0500
Date: Wed, 23 Nov 2011 15:47:43 -0500 (EST)
Message-Id: <20111123.154743.1271851399746346321.davem@davemloft.net> (sfid-20111123_214911_489783_0E55E2A5)
To: sgruszka@redhat.com
Cc: helmut.schaa@googlemail.com, hedayaty@gmail.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	IvDoorn@gmail.com, gwingerde@gmail.com
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111123105106.GA7943@redhat.com>
References: <20111123080506.GB9833@redhat.com>
	<CAGXE3d-HE8MWV5Xv9e407iDn83UFvjua52mYGEJuJnQuQvnyog@mail.gmail.com>
	<20111123105106.GA7943@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 23 Nov 2011 11:51:07 +0100

> On Wed, Nov 23, 2011 at 09:51:38AM +0100, Helmut Schaa wrote:
>> Are we 100% sure that the rt2800pci device is generating the interrupts?
> No, good point. There is also usb_hcd_irq() registered on that line.
> 
> I wonder if there is method to control irq routing.

The IRQ routing is likely determined by the physical line traces on
your motherboard and therefore cannot be changed.
