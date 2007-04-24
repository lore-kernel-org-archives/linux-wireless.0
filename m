Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpsrv03.uni-oldenburg.de ([134.106.87.11]:43041 "EHLO
	smtpsrv03.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423011AbXDXStg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2007 14:49:36 -0400
Message-ID: <462E513A.5000003@mail.uni-oldenburg.de>
Date: Tue, 24 Apr 2007 20:49:30 +0200
From: Stefan Puch <stefan.puch@mail.uni-oldenburg.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linux-net@vger.kernel.org
Subject: Re: prism54: WPA/RSN support for fullmac cards
References: <462336B1.4090006@mail.uni-oldenburg.de>	 <1176732546.27418.9.camel@localhost.localdomain>	 <4625130F.4090104@mail.uni-oldenburg.de>	 <200704171512.32564.flamingice@sourmilk.net> <43e72e890704171324l12ebf189m5837aae95b7143d1@mail.gmail.com>
In-Reply-To: <43e72e890704171324l12ebf189m5837aae95b7143d1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Also -- I think having both drivers is a good thing, they both do
> serve different purposes. Apparently going with a FullMAC design can
> save you some power so prism54 should be good for those purposes. We
> need to update this on the descriptions when we get a chance.

You can also use the FullMAC design to do some wlan sniffing/hacking because it
supports packet injection in Monitor mode!
