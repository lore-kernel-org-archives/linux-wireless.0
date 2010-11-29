Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:64160 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab0K2RJS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 12:09:18 -0500
Subject: Re: [PATCH 2/2 v3] mac80211: add throughput based LED blink trigger
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1291049458.3532.7.camel@jlt3.sipsolutions.net>
References: <1290884614.3700.3.camel@jlt3.sipsolutions.net>
	 <1290885648.3700.4.camel@jlt3.sipsolutions.net>
	 <1290947171.3467.7.camel@jlt3.sipsolutions.net>
	 <1291047211.26829.17.camel@wwguy-ubuntu>
	 <1291049458.3532.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Mon, 29 Nov 2010 09:08:09 -0800
Message-Id: <1291050489.26829.21.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HiJohannes,

On Mon, 2010-11-29 at 08:50 -0800, Johannes Berg wrote:
> On Mon, 2010-11-29 at 08:13 -0800, Guy, Wey-Yi wrote:
> 
> > Do not see how it work for different hardware has different requirement,
> > for example, in iwlwifi, different device has different blink time
> > compensation.
> 
> Well you haven't seen the iwlwifi patch for it yet :-)
> 
> Blink compensation is applied to the values. So if the trigger says
> "blink for 167ms on and 167ms off", blink compensation will be applied
> to the value 167.
> 
fair enough, I will wait :-)

Wey
> 

