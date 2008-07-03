Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:48336 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbYGCOSX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 10:18:23 -0400
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, vinay@linux.vnet.ibm.com,
	krkumar2@in.ibm.com, mchan@broadcom.com, Matheos.Worku@Sun.COM,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 26/39]: netdev: netdev_priv() can now be sane again.
References: <20080703.000446.125029084.davem@davemloft.net>
	<m3tzf7nrd7.fsf@maximus.localdomain>
	<20080703.042614.244608628.davem@davemloft.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 03 Jul 2008 16:18:21 +0200
In-Reply-To: <20080703.042614.244608628.davem@davemloft.net> (David Miller's message of "Thu\, 03 Jul 2008 04\:26\:14 -0700 \(PDT\)")
Message-ID: <m3d4lvnj9u.fsf@maximus.localdomain> (sfid-20080703_161828_426526_E6BBD359)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

> If all drivers call netdev_priv(), there is no confusion :)
>
> I plan to rename dev->priv to dev->_priv and fix all the fallout.

Do you mean practically deleting dev->priv? That would make sense.
-- 
Krzysztof Halasa
