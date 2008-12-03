Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:52888 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYLCRJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 12:09:15 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1546434eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 09:09:12 -0800 (PST)
Subject: Re: Unusually low speeds with ath5k and iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"wally@theblackmoor.net" <wally@theblackmoor.net>
In-Reply-To: <1228323319.12006.3.camel@rc-desk>
References: <492719ED.5000006@gmail.com>  <1228323319.12006.3.camel@rc-desk>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 19:09:07 +0200
Message-Id: <1228324148.23040.0.camel@maxim-laptop> (sfid-20081203_180920_134385_1A12BBF8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-03 at 08:55 -0800, reinette chatre wrote:
> On Fri, 2008-11-21 at 12:28 -0800, Maxim Levitsky wrote:
> 
> > sorry for cross-posting, but this issue really spans both iwl3945 and ath5k.
> > 
> > I have two laptops (acer 5720, and aspire one) and I see some strange speed issues.
> > 
> > I initially blamed iwl3945, then thought it got fixed, but now I have ath5k, and speeds are low
> > and I suspect that both drivers has bugs regarding to speed.
> 
> We just posted some fixes to iwl3945 rate scaling. Could you please test
> with http://marc.info/?l=linux-wireless&m=122824880823630&w=2 ?
> 
> Thank you
> 
> Reinette
> 
> 
I''l test this, but for all my tests rate on iwl3945 was already 54M,
could this still help?

Best regards,
	Maxim Levitsky

