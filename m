Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44607 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZEDRs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 13:48:27 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241458558.8683.84.camel@johannes.local>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
	 <1241453408.8683.53.camel@johannes.local>
	 <1241454909.2903.17.camel@localhost.localdomain>
	 <1241455125.8683.60.camel@johannes.local>
	 <1241455848.2903.18.camel@localhost.localdomain>
	 <1241456088.8683.62.camel@johannes.local>
	 <1241456863.2903.29.camel@localhost.localdomain>
	 <1241458558.8683.84.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 04 May 2009 10:48:15 -0700
Message-Id: <1241459295.2903.40.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > 	Vendor specific: OUI 00:90:4c, data: 33 0c 10 1f ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 	Vendor specific: OUI 00:90:4c, data: 34 03 00 05 00 00 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 	Unknown IE (45): 0c 10 1f ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00
> > 	Unknown IE (61): 03 00 01 00 00 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 	WPS:	 * Version: 1.0
> > 		 * Manufacturer: D-Link Systems
> > 		 * Model: DIR-615
> > 		 * Device name: Wireless N Router
> > 		 * Config methods: Label
> > 
> > I didn't find any specs to decode IE 45 and 61 since all of them mark
> > these as reserved. Not sure if these are defined in future specs or if
> > they are deprecated IE. And it seems its data is similar to what is in
> > the vendor specific elements.
> 
> Both are HT.

do we have the specs somewhere then I might can give it a try. Also WMM
needs some improvements.

> > The other one that keeps showing up in my area is:
> > 
> > 	Unknown IE (47): 06
> 
> "Broadcom proprietary" -- seems it would make sense to ignore that.

Since it not showing up until you give -u there is no need to ignore it,
but where do you find that this is Broadcom proprietary and why the f*
they get to use an official IE number?

> > And I do have some other vendor specific ones, that I don't really care
> > about and we might even never know what they are:
> > 
> > 	Vendor specific: OUI 00:03:7f, data: 01 01 00 17 00 00
> > 	Vendor specific: OUI 00:03:7f, data: 02 01 01 4d 00 03 a4 00 00
> > 	Vendor specific: OUI 00:03:2f, data: 01 00 01
> 
> You can check wireshark, sometimes it has something useful. I think
> there are pre-wifi HT IEs too in some vendor IE, might be one of these.
> 
> https://mentor.ieee.org/802.11/documents?x_dcn=31&x_year=2009 is useful
> too (at least for 2009, for next year somebody will have to find the DCN
> again)

I found an indication of what bit 1 of extended capabilities means. I do
have seen an AP with that somewhere around :)

Regards

Marcel


