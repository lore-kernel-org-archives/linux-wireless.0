Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYJ1XcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 19:32:17 -0400
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1225235731.1369.8.camel@johannes.berg>
References: <20081018231046.GA10977@isilmar.linta.de>
	 <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com>
	 <20081019075916.GA12904@isilmar.linta.de>
	 <1225145468.1115.139.camel@rc-desk>
	 <20081027230326.GA23250@isilmar.linta.de>
	 <1225154823.1115.149.camel@rc-desk>
	 <20081028194323.GA14303@isilmar.linta.de>
	 <1225225434.1115.217.camel@rc-desk>
	 (sfid-20081028_212343_098446_12401F4B)  <1225235731.1369.8.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 16:32:40 -0700
Message-Id: <1225236760.1115.245.camel@rc-desk> (sfid-20081029_003221_575435_E5D6DC35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-28 at 16:15 -0700, Johannes Berg wrote:
> On Tue, 2008-10-28 at 13:23 -0700, reinette chatre wrote:
> 
> > (adding linux-wireless so I am keeping the log below)
> > 
> > This helps a lot - thanks!
> > 
> > Could you please recompile wireless with CONFIG_WIRELESS_OLD_REGULATORY?
> 
> Btw, any idea why this helps? Shouldn't the driver just work, albeit
> with a restricted channel set? Are we messing something up like no
> usable channels at all? (I fixed a bug like that IIRC)
> 

Without the regulatory information the number of 5G channels to scan is
zero.

> [ 1094.582562] iwl3945: U iwl3945_bg_request_scan Kicking off one
indirect scan.
> [ 1094.582574] iwl3945: U iwl3945_get_channels_for_scan total channels
to scan 0

Reinette



