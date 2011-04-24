Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58976 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab1DXSvd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 14:51:33 -0400
Subject: Re: [PATCH 1/1 RFC] mac80211: add ratio to led blinking trigger
From: wwguy <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1303670306.3603.5.camel@jlt3.sipsolutions.net>
References: <1303665300-1775-1-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110424_191812_851726_8A7D5FAA)  <1303670306.3603.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 11:48:40 -0700
Message-ID: <1303670920.22777.10.camel@wwguy-ubuntu> (sfid-20110424_205147_557125_1E080196)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-24 at 11:38 -0700, Johannes Berg wrote:
> On Sun, 2011-04-24 at 10:15 -0700, Wey-Yi Guy wrote:
> > The current led blink trigger implementaion assume on/off time are equal,
> > it works but not have any flexbile for different blink pattern.
> > 
> > Add "ratio" parameter in the trigger table and give driver more control
> > on how the on/off blink time behavior should be.
> 
> I considered this when writing the original code, but then decided that
> nobody needed to have unequal on/off times. Why would we need it now?
> (FWIW, blink = 0 is always on already, no?)
> 
But from what I read for iwlwifi, to turn LED_SOLID_ON, on = 11, off =
0. Did I read it wrong.

Yes, I agree as today, "on" == "off", just thinking we should make more
flexible.

Wey



