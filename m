Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:57813 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbYGaUSv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 16:18:51 -0400
Subject: Re: Driver for the FullMAC card
From: Pavel Roskin <proski@gnu.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1217534415.9377.12.camel@localhost.localdomain>
References: <g6qr98$q28$2@ger.gmane.org>
	 <1217512488.12016.8.camel@localhost.localdomain>
	 <bc64b4640807310715j41bb0029i5c8be73a311ed52@mail.gmail.com>
	 <1217514241.12016.13.camel@localhost.localdomain>
	 <1217517571.22143.17.camel@dv>
	 <1217534415.9377.12.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 16:18:49 -0400
Message-Id: <1217535529.15900.4.camel@dv> (sfid-20080731_221854_394191_7A9882E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-07-31 at 16:00 -0400, Dan Williams wrote:

> Guess I misunderstood the scope of p80211 then.  So the prism2 usb stuff
> really is fullmac then?  Or at least quasi-mac like the ipw2x00 cards?

It's as FullMAC as it can get.  It's the same Prism chipset, just
connected to the host system in a different way.  I don't think it's
doing anything differently on the wireless side.

Sure enough, there are some knobs to dumb it down, but probably not to
the SoftMAC level.  I don't think it was tried, and I don't think it's
worth trying.

-- 
Regards,
Pavel Roskin
