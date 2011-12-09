Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab1LISmu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 13:42:50 -0500
Subject: Re: iwlwifi havoc on some APs (rekeying?)
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: Wolfgang Breyha <wbreyha@gmx.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1323455216.3622.21.camel@jlt3.sipsolutions.net>
References: <4EE2202A.4080303@gmx.net>
	 <1323446534.13074.96.camel@wwguy-huron>  <4EE24DF4.4020301@gmx.net>
	 <1323451436.13074.158.camel@wwguy-huron>
	 (sfid-20111209_192243_598986_F6275AE2)  <1323455216.3622.21.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 09:44:09 -0800
Message-ID: <1323452649.13074.164.camel@wwguy-huron> (sfid-20111209_194254_301821_F1F8CFBA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-09 at 10:26 -0800, Berg, Johannes wrote:
> On Fri, 2011-12-09 at 09:23 -0800, Guy, Wey-Yi wrote:
> > Johannes,
> > 
> > Anything changed in this area?
> 
> What's "this area"? This isn't exactly the first report of random memory
> corruption ... I think the last one was something with 32/64 bit but I
> don't remember.
> 

yup, what I mean is do you have any thought on this? I am not sure how
to reproduce this issue with the APs we have here. 

Something happen between March 2011 and now, bisect it? but we need to
be able to reproduce the failure case first.

Thanks
Wey
> 


