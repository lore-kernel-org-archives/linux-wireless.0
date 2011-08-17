Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:42219 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1HQGUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 02:20:38 -0400
Message-ID: <4E4B5DC5.9090304@01019freenet.de> (sfid-20110817_082043_445634_6FDA201D)
Date: Wed, 17 Aug 2011 08:20:53 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Ivo Van Doorn <ivdoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 7 more packets after each beacon frame
References: <4E4AB695.5070300@01019freenet.de> <CAOZOX0UsRxT9ECdUC7OL2toJUb+PitGhxCifTyD8hWYwt6R_zg@mail.gmail.com> <4E4ACD10.7000807@01019freenet.de> <CAGXE3d-hb2MnLW+NhxCBhUSGTNSs5ki9-6wo5uQGSJbFdEB5KA@mail.gmail.com>
In-Reply-To: <CAGXE3d-hb2MnLW+NhxCBhUSGTNSs5ki9-6wo5uQGSJbFdEB5KA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa schrieb:
> On Tue, Aug 16, 2011 at 10:03 PM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
>>> When examining my own AP (rt2860 based) with another STA in monitor
>>> mode, I can see always 7 packets after each beacon frame:
> 
> That looks quite odd. Maybe some garbage ended up in the beacon slots
> after the first beacon.
> Do you use multiple virtual interfaces?

I removed _all_ of my network devices (but lo) and tested again (on a
now clean machine :-)). The complete module stack for rt2800pci was
unloaded and loaded again. I could see the same odd packages again.


Andreas
