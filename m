Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:37465 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbYGCMBH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 08:01:07 -0400
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, vinay@linux.vnet.ibm.com,
	krkumar2@in.ibm.com, mchan@broadcom.com, Matheos.Worku@Sun.COM,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 26/39]: netdev: netdev_priv() can now be sane again.
References: <20080703.000446.125029084.davem@davemloft.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 03 Jul 2008 13:23:32 +0200
In-Reply-To: <20080703.000446.125029084.davem@davemloft.net> (David Miller's message of "Thu\, 03 Jul 2008 00\:04\:46 -0700 \(PDT\)")
Message-ID: <m3tzf7nrd7.fsf@maximus.localdomain> (sfid-20080703_140433_582270_19DAE233)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

> The private area of a netdev is now at a fixed offset once more.
>
> Unfortunately, some assumptions that netdev_priv() == netdev->priv
> crept back into the tree.  In particular this happened in the
> loopback driver.

Perhaps the netdev_priv() should be renamed to avoid confusion?
-- 
Krzysztof Halasa
