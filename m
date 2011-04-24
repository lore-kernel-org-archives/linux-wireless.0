Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19822 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab1DXTwF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 15:52:05 -0400
Subject: Re: [PATCH 1/1 RFC] mac80211: add ratio to led blinking trigger
From: wwguy <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1303674298.3603.9.camel@jlt3.sipsolutions.net>
References: <1303665300-1775-1-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110424_191812_851726_8A7D5FAA) <1303670306.3603.5.camel@jlt3.sipsolutions.net>
	 <1303670920.22777.10.camel@wwguy-ubuntu>
	 <1303673360.3603.7.camel@jlt3.sipsolutions.net>
	 <1303673834.22777.15.camel@wwguy-ubuntu>
	 <1303674298.3603.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 12:49:12 -0700
Message-ID: <1303674552.22777.17.camel@wwguy-ubuntu> (sfid-20110424_215222_576918_7E6F80C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-24 at 12:44 -0700, Johannes Berg wrote:
> On Sun, 2011-04-24 at 12:37 -0700, wwguy wrote:
> 
> > > So if you want "solid on" by default for 0 tpt, you simply don't specify
> > > the -1 value, ie. just remove the -1 line from the table completely.
> > > IOW, instead of the patch you posted before, a simple patch just
> > > removing the first line from the table should be sufficient.
> > > 
> > > > Yes, I agree as today, "on" == "off", just thinking we should make more
> > > > flexible.
> > > 
> > > I just don't see the point since we don't really need it.
> > 
> > Just thinking give more control to the driver, but it is ok don't have
> > it
> 
> I wouldn't really mind, I just don't think it's useful before some
> driver actually needs it, and all the current ones want symmetric
> blinking (and also I think asymmetric would look odd).
> 
well, if you think it is ok, then I will submit it, or I will just drop
it.

Wey


