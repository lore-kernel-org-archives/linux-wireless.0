Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:33372 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab2DRMcn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 08:32:43 -0400
Date: Wed, 18 Apr 2012 15:33:28 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
Message-ID: <20120418123326.GF19228@aemeltch-MOBL1> (sfid-20120418_143248_703121_5ECF65FB)
References: <4F846257.1060807@sipsolutions.net>
 <1334092668.16897.54.camel@aeonflux>
 <4F84A422.3030900@sipsolutions.net>
 <1334093378.16897.62.camel@aeonflux>
 <20120411070514.GB17779@aemeltch-MOBL1>
 <1334714841.3725.37.camel@jlt3.sipsolutions.net>
 <20120418112017.GC19228@aemeltch-MOBL1>
 <1334749879.16897.221.camel@aeonflux>
 <20120418121014.GD19228@aemeltch-MOBL1>
 <1334751359.16897.225.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1334751359.16897.225.camel@aeonflux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

On Wed, Apr 18, 2012 at 02:15:59PM +0200, Marcel Holtmann wrote:
> > > This is also a little bit of confusing since FullMac cards will not
> > > create an AMP virtual interface. With them you just see the HCI AMP
> > > controller on the Bluetooth side. Can an AMP virtual interface be just
> > > virtual inside mac80211 or does it have to have a netdev attached to it?
> > 
> > If we create virtual interface then netdev is allocated and we can handle
> > it with common tools.
> 
> what common tools do you wanna use here. We actually do not wanna have
> them show up as netdev devices at all. AMP connections don't have IP
> addresses or anything else for that matter.

I might want to set up MAC address. Otherwise I might not need netdev. I
feel that I need it for interface separation.

Best regards 
Andrei Emeltchenko 
 
