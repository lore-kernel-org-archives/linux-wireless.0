Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32613 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbYJ2Phe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 11:37:34 -0400
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1225280921.5439.2.camel@johannes.berg>
References: <20081018231046.GA10977@isilmar.linta.de>
	 <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com>
	 <20081019075916.GA12904@isilmar.linta.de>
	 <1225145468.1115.139.camel@rc-desk>
	 <20081027230326.GA23250@isilmar.linta.de>
	 <1225154823.1115.149.camel@rc-desk>
	 <20081028194323.GA14303@isilmar.linta.de>
	 <1225225434.1115.217.camel@rc-desk>
	 (sfid-20081028_212343_098446_12401F4B) <1225235731.1369.8.camel@johannes.berg>
	 <1225236760.1115.245.camel@rc-desk> <1225280921.5439.2.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 08:37:53 -0700
Message-Id: <1225294673.1115.251.camel@rc-desk> (sfid-20081029_163738_731983_809E794A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-29 at 04:48 -0700, Johannes Berg wrote:
> On Tue, 2008-10-28 at 16:32 -0700, reinette chatre wrote:
> 
> > Without the regulatory information the number of 5G channels to scan is
> > zero.
> > 
> > > [ 1094.582562] iwl3945: U iwl3945_bg_request_scan Kicking off one
> > indirect scan.
> > > [ 1094.582574] iwl3945: U iwl3945_get_channels_for_scan total channels
> > to scan 0
> 
> That, however, is a valid case either way, if I move to a country that
> doesn't allow using 5 GHz band at all, or not those channels that your
> SKU ships.

yes - the driver should not send a command to hw in this case.  

Reinette

