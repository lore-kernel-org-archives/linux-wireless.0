Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62445 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbZGIX0u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 19:26:50 -0400
Subject: Re: [ipw3945-devel] iwlwifi 4965 uCode available
From: reinette chatre <reinette.chatre@intel.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <b170af450907091613l1607f664he482e13e6fe268bd@mail.gmail.com>
References: <1247174482.17896.1304.camel@rc-desk>
	 <b170af450907091613l1607f664he482e13e6fe268bd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jul 2009 16:26:50 -0700
Message-Id: <1247182010.17896.1344.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-09 at 16:13 -0700, Rafał Miłecki wrote:
> 2009/7/9 reinette chatre <reinette.chatre@intel.com>:
> > Version 228.61.2.24 of uCode for Intel Wireless WiFi Link 4965AGN is now
> > available for download from
> > http://intellinuxwireless.org/?n=Downloads
> >
> > Changes:
> >
> > -- More graceful handling of Rx hangs (NMI)
> > -- More reliable scanning
> > -- Wait 10 seconds after association before power down
> > -- Reset receiver via retune after missing beacons
> > -- Disable TGK measurement when receiving packet
> > -- More reliable Tx of ACK/BA/CTS
> 
> Nice work, AFAICU this should fix a few annoying issues, right?

We hope so. 

> Can you reveal some plans of upgrading 5100/5300/5350 uCode? Any
> estimate would be nice to known. This month? This year?

I am not aware of any scheduled date for a new release. Are there
critical issues that you are aware of that requires a new uCode?

Reinette


