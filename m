Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58546 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2DRNMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 09:12:22 -0400
Message-ID: <1334754717.16897.228.camel@aeonflux> (sfid-20120418_151247_508989_3DCE6D59)
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
From: Marcel Holtmann <marcel@holtmann.org>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Wed, 18 Apr 2012 15:11:57 +0200
In-Reply-To: <20120418123326.GF19228@aemeltch-MOBL1>
References: <4F846257.1060807@sipsolutions.net>
	 <1334092668.16897.54.camel@aeonflux> <4F84A422.3030900@sipsolutions.net>
	 <1334093378.16897.62.camel@aeonflux>
	 <20120411070514.GB17779@aemeltch-MOBL1>
	 <1334714841.3725.37.camel@jlt3.sipsolutions.net>
	 <20120418112017.GC19228@aemeltch-MOBL1>
	 <1334749879.16897.221.camel@aeonflux>
	 <20120418121014.GD19228@aemeltch-MOBL1>
	 <1334751359.16897.225.camel@aeonflux>
	 <20120418123326.GF19228@aemeltch-MOBL1>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrei,

> > > > This is also a little bit of confusing since FullMac cards will not
> > > > create an AMP virtual interface. With them you just see the HCI AMP
> > > > controller on the Bluetooth side. Can an AMP virtual interface be just
> > > > virtual inside mac80211 or does it have to have a netdev attached to it?
> > > 
> > > If we create virtual interface then netdev is allocated and we can handle
> > > it with common tools.
> > 
> > what common tools do you wanna use here. We actually do not wanna have
> > them show up as netdev devices at all. AMP connections don't have IP
> > addresses or anything else for that matter.
> 
> I might want to set up MAC address. Otherwise I might not need netdev. I
> feel that I need it for interface separation.

what MAC address? And where do you get this MAC address from? AMP
controllers do not have MAC addresses.

Regards

Marcel


