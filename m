Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46119
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757448AbYGCWzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 18:55:39 -0400
Date: Thu, 03 Jul 2008 15:55:38 -0700 (PDT)
Message-Id: <20080703.155538.127636390.davem@davemloft.net> (sfid-20080704_005604_636050_7BE683F9)
To: khc@pm.waw.pl
Cc: netdev@vger.kernel.org, vinay@linux.vnet.ibm.com,
	krkumar2@in.ibm.com, mchan@broadcom.com, Matheos.Worku@Sun.COM,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 26/39]: netdev: netdev_priv() can now be sane again.
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3d4lvnj9u.fsf@maximus.localdomain>
References: <m3tzf7nrd7.fsf@maximus.localdomain>
	<20080703.042614.244608628.davem@davemloft.net>
	<m3d4lvnj9u.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 03 Jul 2008 16:18:21 +0200

> David Miller <davem@davemloft.net> writes:
> 
> > If all drivers call netdev_priv(), there is no confusion :)
> >
> > I plan to rename dev->priv to dev->_priv and fix all the fallout.
> 
> Do you mean practically deleting dev->priv? That would make sense.

Yes, that's the basic idea.  It's probably the only way to
prevent this problem in the future.
