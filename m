Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26460 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYLCRgF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 12:36:05 -0500
Subject: Re: Unusually low speeds with ath5k and iwl3945
From: reinette chatre <reinette.chatre@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"wally@theblackmoor.net" <wally@theblackmoor.net>
In-Reply-To: <1228324148.23040.0.camel@maxim-laptop>
References: <492719ED.5000006@gmail.com>  <1228323319.12006.3.camel@rc-desk>
	 <1228324148.23040.0.camel@maxim-laptop>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 09:36:58 -0800
Message-Id: <1228325818.13338.3.camel@rc-desk> (sfid-20081203_183611_067329_08E03E75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-03 at 09:09 -0800, Maxim Levitsky wrote:
> On Wed, 2008-12-03 at 08:55 -0800, reinette chatre wrote:
> > On Fri, 2008-11-21 at 12:28 -0800, Maxim Levitsky wrote:
> > 
> > > sorry for cross-posting, but this issue really spans both iwl3945 and ath5k.
> > > 
> > > I have two laptops (acer 5720, and aspire one) and I see some strange speed issues.
> > > 
> > > I initially blamed iwl3945, then thought it got fixed, but now I have ath5k, and speeds are low
> > > and I suspect that both drivers has bugs regarding to speed.
> > 
> > We just posted some fixes to iwl3945 rate scaling. Could you please test
> > with http://marc.info/?l=linux-wireless&m=122824880823630&w=2 ?
> > 
> > Thank you
> > 
> > Reinette
> > 
> > 
> I''l test this, but for all my tests rate on iwl3945 was already 54M,
> could this still help?
> 

Yes. Please test with netcat as you did previously to see if you get
better performance.

Thanks

Reinette

