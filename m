Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab1DYHWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 03:22:41 -0400
Subject: Re: [PATCH 1/1 RFC] mac80211: add ratio to led blinking trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1303674552.22777.17.camel@wwguy-ubuntu>
References: <1303665300-1775-1-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110424_191812_851726_8A7D5FAA) <1303670306.3603.5.camel@jlt3.sipsolutions.net>
	 <1303670920.22777.10.camel@wwguy-ubuntu>
	 <1303673360.3603.7.camel@jlt3.sipsolutions.net>
	 <1303673834.22777.15.camel@wwguy-ubuntu>
	 <1303674298.3603.9.camel@jlt3.sipsolutions.net>
	 <1303674552.22777.17.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Apr 2011 09:22:34 +0200
Message-ID: <1303716154.3628.0.camel@jlt3.sipsolutions.net> (sfid-20110425_092244_669617_41751158)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-24 at 12:49 -0700, wwguy wrote:
> On Sun, 2011-04-24 at 12:44 -0700, Johannes Berg wrote:
> > On Sun, 2011-04-24 at 12:37 -0700, wwguy wrote:
> > 
> > > > So if you want "solid on" by default for 0 tpt, you simply don't specify
> > > > the -1 value, ie. just remove the -1 line from the table completely.
> > > > IOW, instead of the patch you posted before, a simple patch just
> > > > removing the first line from the table should be sufficient.
> > > > 
> > > > > Yes, I agree as today, "on" == "off", just thinking we should make more
> > > > > flexible.
> > > > 
> > > > I just don't see the point since we don't really need it.
> > > 
> > > Just thinking give more control to the driver, but it is ok don't have
> > > it
> > 
> > I wouldn't really mind, I just don't think it's useful before some
> > driver actually needs it, and all the current ones want symmetric
> > blinking (and also I think asymmetric would look odd).
> > 
> well, if you think it is ok, then I will submit it, or I will just drop
> it.

I'd prefer not having it until we need it for some driver.

johannes

